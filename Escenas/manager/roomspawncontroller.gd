extends Node
class_name Global

@export var door_scene: PackedScene = null
var player_scene: PackedScene = preload("res://Escenas/personaje/Player.tscn")
var player_instance: Node2D = null

var rooms = ["res://Escenas/Rooms/room_1.tscn",
			"res://Escenas/Rooms/room_prueba.tscn",
			"res://Escenas/Rooms/room_cruz.tscn"
			
			]
var cerrar_barrera = true
var cuarto_inicial_borrado = false
# sentinel: Vector2.ZERO = "no hay marker pendiente"
var posicion_puerta_nueva: Vector2 = Vector2.ZERO
var door_actual: Door = null


# seguimiento de rooms
var room_actual: Node = null
var room_previous: Node = null
var starter_room: Node = null 


# protección contra reentradas
var _cloning_in_progress: bool = false


func _ready() -> void:
	
	
	pass
	

# ---------------- PUERTAS ----------------
func register_door(door: Door) -> void:
	door_actual = door
	print("Door registrada:", door.name)

func report_marker_position(pos: Vector2) -> void:
	posicion_puerta_nueva = pos
	print("Marker instanciado en:", posicion_puerta_nueva)

func _process(delta: float) -> void:
	if posicion_puerta_nueva == Vector2.ZERO:
		return
	if _cloning_in_progress:
		return

	_cloning_in_progress = true

	var vieja: Door = door_actual
	var nueva: Door = null

	if vieja and is_instance_valid(vieja):
		nueva = vieja.duplicate()
	else:
		if door_scene:
			nueva = door_scene.instantiate() as Door
		else:
			push_warning("No hay door_actual ni door_scene exportada; abortando clonación.")
			_cloning_in_progress = false
			posicion_puerta_nueva = Vector2.ZERO
			return

	get_tree().current_scene.add_child(nueva)
	await get_tree().process_frame

	nueva.global_position = posicion_puerta_nueva
	door_actual = nueva

	if vieja and is_instance_valid(vieja):
		vieja.call_deferred("queue_free")

	print("Door clonada y reemplazada. Nueva door en:", door_actual.global_position)

	posicion_puerta_nueva = Vector2.ZERO
	_cloning_in_progress = false

# ---------------- CUARTOS ----------------
# Al crear la room: guardamos la anterior en room_previous, añadimos la nueva y la ponemos como room_actual
func on_player_touch_x(posicion_puerta: Vector2) -> void:
	print("Creando cuarto en:", posicion_puerta)
	var scene_path = rooms.pick_random()
	var room_scene: PackedScene = load(scene_path)
	var nuevo_room = room_scene.instantiate()

	# 1) Guardamos la referencia a la room actual como "previous"
	room_previous = room_actual

	# 2) Añadimos la nueva y la hacemos la actual
	nuevo_room.global_position = posicion_puerta
	add_child(nuevo_room)

	# opcional: esperar un frame si necesitás que la room ejecute su _ready()
	# await get_tree().process_frame

	room_actual = nuevo_room
	print("Nuevo cuarto seteado:", room_actual.name)
	# NOTA: no borramos aquí; borrado lo hace delete_previous_room() cuando corresponda

# función que puede ser llamada por marker/puerta para indicar room a borrar (dejé por compatibilidad)
func report_marker_parent(parent_node: Node) -> void:
	# ya no la usamos para borrar; la dejamos para debug si querés
	print("Marker pertenece a:", parent_node.name)

# Cuando el jugador entra al cuarto nuevo: cerramos la barrera y borramos la room anterior
# Cuando el jugador entra al cuarto nuevo: cerramos la barrera y borramos la room anterior
func on_player_entra_cuarto_nuevo(barrera_entrada: Node) -> void:
	print("Jugador entra a cuarto nuevo")

	# 1) Primero: borrar cuarto anterior
	delete_previous_room()
	await get_tree().process_frame

	# 2) Ahora sí cerrar la barrera de la room nueva
	# IMPORTANTE: no uses la referencia vieja, buscá la barrera en la room actual
	var barrera_actual := get_tree().get_first_node_in_group("sprite_barrera_entrada")
	if barrera_actual and is_instance_valid(barrera_actual):
		barrera_actual.enabled = cerrar_barrera
		print("Barrera cerrada (de la room actual)")
	else:
		push_warning("No se encontró barrera válida para cerrar después del borrado")


func avisarstarterroon(current_room):
	starter_room = current_room


# borrado seguro de la room anterior
func delete_previous_room() -> void:
	# Prioridad: borrar room_previous
	if room_previous and is_instance_valid(room_previous):
		print("Borrando room anterior:", room_previous.name)
		room_previous.call_deferred("queue_free")
		room_previous = null
		return
	
	# Si no hay previous, borramos starter room
	if starter_room:
		print("Borrando starter room:", starter_room.name)
		starter_room.call_deferred("queue_free")
		cuarto_inicial_borrado = true
		return
	print("No hay room previa ni starter room para borrar")

	

# ---------------- PLAYER SPAWN ----------------
func reportar_posicion_spawnear_jugador(global_position_marker: Vector2) -> void:
	print("vamos a spawnear al jugador en la posicion:", global_position_marker)

	# Evitar repetir player
	if player_instance and is_instance_valid(player_instance):
		player_instance.global_position = global_position_marker
		print("Player movido a:", player_instance.global_position)
		return

	if not player_scene:
		push_error("player_scene no asignada")
		return

	player_instance = player_scene.instantiate() as Node2D
	get_tree().current_scene.add_child(player_instance)
	await get_tree().process_frame
	if player_instance is Node2D:
		player_instance.global_position = global_position_marker
		print("Player instanciado y colocado en:", player_instance.global_position)
	else:
		push_error("El Player no es Node2D")
		player_instance = null
		
var region_dim_1: NavigationRegion2D
var region_dim_2: NavigationRegion2D

func registrar_regiones(r1: NavigationRegion2D, r2: NavigationRegion2D):
	region_dim_1 = r1
	region_dim_2 = r2 
	region_dim_2.enabled = false
	disable_bodies(region_dim_2)
	print("Regiones registradas correctamente", region_dim_1, region_dim_2)

var dimension_actual := 1  # 1 o 2

func toggle_dimension():

	if dimension_actual == 1:
		# Pasamos a dimensión 2
		dimension_actual = 2

		region_dim_1.enabled = false
		region_dim_2.enabled = true

		disable_bodies(region_dim_1)
		enable_bodies(region_dim_2, 2, 0)

	else:
		# Pasamos a dimensión 1
		dimension_actual = 1

		region_dim_2.enabled = false
		region_dim_1.enabled = true

		disable_bodies(region_dim_2)
		enable_bodies(region_dim_1, 1, 0)

	print("Dimensión actual:", dimension_actual)

	# Forzar recalculo de path en los agentes
	for agent in get_tree().get_nodes_in_group("nav_agents"):
		agent.target_position = agent.target_position

func disable_bodies(root: Node):
	for body in root.get_children():
		if body is StaticBody2D:
			body.set_deferred("collision_layer", 0)
			
func enable_bodies(root: Node, layer: int, mask: int = 0):
	for body in root.get_children():
		if body is StaticBody2D:
			body.set_deferred("collision_layer", layer)
			body.set_deferred("collision_mask", mask)

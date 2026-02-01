extends Node
class_name Global

@export var door_scene: PackedScene = null
var player_scene: PackedScene = preload("res://Escenas/personaje/Player.tscn")
var player_instance: Node2D = null

var rooms = [
	"res://Escenas/Rooms/room_1.tscn",
	"res://Escenas/Rooms/room_prueba.tscn",
	"res://Escenas/Rooms/room_cruz.tscn"
]

var cerrar_barrera = true
var cuarto_inicial_borrado = false

# sentinel: Vector2.ZERO = "no hay marker pendiente"
var posicion_puerta_nueva: Vector2 = Vector2.ZERO
var door_actual: Door = null
var jugador_esta_listo = false

# seguimiento de rooms
var room_actual: Node = null
var room_previous: Node = null
var starter_room: Node = null

# protección contra reentradas
var _cloning_in_progress: bool = false

# ---------------- NAVMESH / DIMENSIONES ----------------
var region_dim_1: NavigationRegion2D
var region_dim_2: NavigationRegion2D

# COLLISION LAYERS:
# - Dimensión 1 → layer 1 (valor 1)
# - Dimensión 2 → layer 2 (valor 2)
# - Player/enemigos/agentes → layer 1 (o lo que uses), pero MASK = 3 (colisiona con layer 1 y 2)
const PLAYER_COLLISION_MASK: int = 3  # <--- CLAVE: 3 = bits 1 y 2 → player choca con AMBAS dimensiones

var dimension_actual := 1 # 1 o 2

func registrar_regiones(r1: NavigationRegion2D, r2: NavigationRegion2D) -> void:
	region_dim_1 = r1
	region_dim_2 = r2
	
	# Estado inicial
	_set_dimension_active(region_dim_1, true, 1)
	_set_dimension_active(region_dim_2, false, 2)
	
	print("Regiones registradas correctamente")

func toggle_dimension() -> void:
	if dimension_actual == 1:
		dimension_actual = 2
		_set_dimension_active(region_dim_1, false, 1)
		_set_dimension_active(region_dim_2, true, 2)
	else:
		dimension_actual = 1
		_set_dimension_active(region_dim_2, false, 2)
		_set_dimension_active(region_dim_1, true, 1)
	
	print("Dimensión actual:", dimension_actual)
	
	# Forzar recalculo pathfinding
	for agent in get_tree().get_nodes_in_group("nav_agents"):
		if agent is NavigationAgent2D:
			agent.target_position = agent.target_position

# Función central: activa/desactiva navmesh + colisiones RECURSIVAS (llega a TODO)
func _set_dimension_active(region: NavigationRegion2D, active: bool, dim_layer: int) -> void:
	if not region:
		return
	
	region.enabled = active
	
	print("Activando dimensión layer %d: %s" % [dim_layer, "ACTIVA" if active else "DESACTIVADA"])
	
	_set_collision_recursive(region, active, dim_layer)

# RECURSIVA PROFUNDA: llega a StaticBody2D aunque estén dentro de Clutter/Clutter2/Clutter3/etc.
func _set_collision_recursive(node: Node, active: bool, dim_layer: int) -> void:
	if node is CollisionObject2D:  # StaticBody2D, Area2D, etc.
		var old_layer = node.collision_layer
		var old_mask = node.collision_mask
		
		node.set_deferred("collision_layer", dim_layer if active else 0)
		node.set_deferred("collision_mask", PLAYER_COLLISION_MASK if active else 0)
		
		print("   -> %s: layer %d → %d | mask %d → %d" % [
			node.name,
			old_layer,
			node.collision_layer,
			old_mask,
			node.collision_mask
		])
	
	# Recorre TODOS los hijos (profundidad ilimitada)
	for child in node.get_children():
		_set_collision_recursive(child, active, dim_layer)

# ---------------- EL RESTO DE TU CÓDIGO (sin cambios) ----------------
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
func on_player_touch_x(posicion_puerta: Vector2) -> void:
	print("Creando cuarto en:", posicion_puerta)
	var scene_path = rooms.pick_random()
	var room_scene: PackedScene = load(scene_path)
	var nuevo_room = room_scene.instantiate()
	
	room_previous = room_actual
	nuevo_room.global_position = posicion_puerta
	add_child(nuevo_room)
	room_actual = nuevo_room
	print("Nuevo cuarto seteado:", room_actual.name)

func report_marker_parent(parent_node: Node) -> void:
	print("Marker pertenece a:", parent_node.name)

func on_player_entra_cuarto_nuevo(barrera_entrada: Node) -> void:
	print("Jugador entra a cuarto nuevo")
	delete_previous_room()
	await get_tree().process_frame
	
	var barrera_actual := get_tree().get_first_node_in_group("sprite_barrera_entrada")
	if barrera_actual and is_instance_valid(barrera_actual):
		barrera_actual.enabled = cerrar_barrera
		print("Barrera cerrada (de la room actual)")
	else:
		push_warning("No se encontró barrera válida para cerrar después del borrado")

func avisarstarterroon(current_room):
	starter_room = current_room

func delete_previous_room() -> void:
	if room_previous and is_instance_valid(room_previous):
		print("Borrando room anterior:", room_previous.name)
		room_previous.call_deferred("queue_free")
		room_previous = null
		return
	
	if starter_room:
		print("Borrando starter room:", starter_room.name)
		starter_room.call_deferred("queue_free")
		cuarto_inicial_borrado = true
		return
	
	print("No hay room previa ni starter room para borrar")

# ---------------- PLAYER SPAWN ----------------
func reportar_posicion_spawnear_jugador(global_position_marker: Vector2) -> void:
	print("vamos a spawnear al jugador en la posicion:", global_position_marker)
	
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

extends Node


@export var door_scene: PackedScene = null
var player_scene: PackedScene = preload("res://Escenas/personaje/Player.tscn")
var player_instance: Node2D = null
var enemigos_en_escena = 0


var rooms = [
	"res://Escenas/Rooms/room_prueba.tscn",
	"res://Escenas/Rooms/room_L_shape.tscn"
	
]

var cerrar_barrera = true
var cuarto_inicial_borrado = false

var posicion_puerta_nueva: Vector2 = Vector2.ZERO
var door_actual: Door = null
var jugador_esta_listo = false

var room_actual: Node = null
var room_previous: Node = null
var starter_room: Node = null

var _cloning_in_progress: bool = false


# ---------------- EL RESTO DEL CÓDIGO (sin cambios) ----------------
func _ready() -> void:
	pass

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
	enemigos_en_escena = 1
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

func update_enemigo_muerto():
	enemigos_en_escena = enemigos_en_escena-1
	print("quedan" , enemigos_en_escena, " enemigos")

func update_enemigo_vivo():
	enemigos_en_escena = enemigos_en_escena+1
	print("quedan" , enemigos_en_escena, " enemigos")
	
#-------------------RESET-----------------------

func reset():
	print("Reset Roomspawncontroller")

	player_instance = null
	enemigos_en_escena = 0

	posicion_puerta_nueva = Vector2.ZERO
	door_actual = null
	jugador_esta_listo = false

	room_actual = null
	room_previous = null
	starter_room = null

	_cloning_in_progress = false
	cerrar_barrera = true
	cuarto_inicial_borrado = false

func clear_starter_room():
	if starter_room and is_instance_valid(starter_room):
		for child in starter_room.get_children():
			child.queue_free()
		print("Starter room vaciada")
	else:
		print("No hay starter_room válida")

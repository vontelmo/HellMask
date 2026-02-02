extends Node
class_name Pausa

# Arrastrá tu CanvasLayer / Control de pausa acá (opcional pero recomendado)
@export var pause_menu: CanvasItem

# Opcional: si querés ignorar pausa cuando estás en ciertos menús
@export var allow_pause := true

var is_paused: bool = false

func _ready() -> void:
	# CLAVE: este nodo sigue recibiendo input aunque el árbol esté pausado
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Asegurar que el menú (si existe) se pueda usar en pausa
	if pause_menu != null:
		pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
		pause_menu.visible = false

func _input(event: InputEvent) -> void:
	if not allow_pause:
		return

	if event.is_action_pressed("pausa"):
		toggle_pause()
		# evita doble lectura si hay UI abajo
		get_viewport().set_input_as_handled()

func toggle_pause() -> void:
	if is_paused:
		resume()
	else:
		pause()

func pause() -> void:
	is_paused = true
	get_tree().paused = true

	# Mostrar menú sin que se congele
	if pause_menu != null:
		pause_menu.visible = true

	# Mouse visible para UI
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func resume() -> void:
	is_paused = false
	get_tree().paused = false

	if pause_menu != null:
		pause_menu.visible = false

	# Si tu juego usa mouse capturado (FPS), acá lo reactivás.
	# Para un top-down normalmente lo dejás visible.
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func pausar() -> void:
	# compatibilidad con tu función vieja
	toggle_pause()

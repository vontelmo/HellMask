extends UpgradeButton

@export var speed_add := 60.0  # cuánto suma
# o si preferís multiplicar, usá: @export var speed_mult := 1.25

@onready var player := get_tree().get_first_node_in_group("player") as Player

func _ready() -> void:
	titulo = "VELOCIDAD +"
	super._ready()
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	ControladorPausa.toggle_pause()

	if player == null:
		push_warning("No se encontró Player en grupo 'player'")
		return

	# aplicar mejora
	player._velocidad += 60
	# o: player.multiply_speed(speed_mult)

	# cerrar el menú completo (padre del botón)
	get_parent().queue_free()

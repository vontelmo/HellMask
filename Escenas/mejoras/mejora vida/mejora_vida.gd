extends UpgradeButton

@export var health_add := 25.0

@onready var player := get_tree().get_first_node_in_group("player") as Player

func _ready() -> void:
	titulo = "VIDA +"
	super._ready()
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# salir de pausa
	ControladorPausa.toggle_pause()

	if player == null:
		push_warning("No se encontró Player en grupo 'player'")
		return

	# aplicar mejora de vida
	player._health += health_add


	# cerrar el menú de mejoras (padre)
	get_parent().queue_free()

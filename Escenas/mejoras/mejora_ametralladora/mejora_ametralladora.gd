extends UpgradeButton

@onready var weapon_socket := get_tree() \
	.get_first_node_in_group("player") \
	.get_node_or_null("WeaponSocket")

func _ready() -> void:
	titulo = ""
	super._ready()
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	print("pausado puta")
	ControladorPausa.toggle_pause()

	if weapon_socket == null:
		push_warning("No se encontró WeaponSocket")
		return

	print("cambiando a escopeta")
	weapon_socket.cambiar_arma(2)

	# borrar el menú (padre)
	get_parent().queue_free()

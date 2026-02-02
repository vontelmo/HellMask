extends Node2D

@export var armas: Array[PackedScene]
@export var radius := 32.0
@export var deadzone_radius := 40.0  # zona muerta alrededor del player

var last_dir := Vector2.RIGHT
@export var rot_speed := 15.0
@onready var sprite := $Sprite2D  # o AnimatedSprite2D, el que tengas

var instanciated_armas: Array[Node2D] = []
var arma_actual: Node2D = null
var indice_actual := -1

func _ready() -> void:
	for arma in armas:
		instanciated_armas.append(arma.instantiate())

	# arma inicial
	cambiar_arma(2)

func _process(delta: float) -> void:

	var mouse_pos := get_global_mouse_position()
	var to_mouse := mouse_pos - global_position
	var dist := to_mouse.length()

	if dist > deadzone_radius:
		last_dir = to_mouse.normalized()

	position = last_dir * radius
	
	var target_angle = last_dir.angle()
	rotation = lerp_angle(rotation, target_angle, rot_speed * delta)

	var dir := (get_global_mouse_position() - global_position).normalized()
	position = dir * radius
	rotation = dir.angle()
	
	if dir.length() > deadzone_radius:
		last_dir = dir.normalized()

	position = last_dir * radius
	rotation = last_dir.angle()

	if arma_actual and arma_actual.has_method("actualizar_flip"):
		arma_actual.actualizar_flip(last_dir)
	var player = get_parent()
	if player.has_method("actualizar_flip"):
		player.actualizar_flip(last_dir)

func cambiar_arma(nueva_arma: int) -> void:
	if nueva_arma < 0 or nueva_arma >= instanciated_armas.size():
		return

	# sacar la anterior si realmente está como hija
	if arma_actual != null and arma_actual.get_parent() == self:
		remove_child(arma_actual)

	# poner la nueva
	arma_actual = instanciated_armas[nueva_arma]
	indice_actual = nueva_arma
	add_child(arma_actual)

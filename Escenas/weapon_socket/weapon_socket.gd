extends Node2D

@export var armas: Array[PackedScene]
@export var radius := 32.0
var instanciated_armas: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for arma in armas:
		instanciated_armas.append(arma.instantiate())
	add_child(instanciated_armas[2])
	pass # Replace with function body.

# Called every frame. 'delta' is the elapssaed time since the previous frame.
func _process(delta: float) -> void:
	var dir := (get_global_mouse_position() - global_position).normalized()

	# posición circular
	position = dir * radius

	# rotación para apuntar
	rotation = dir.angle()
	pass

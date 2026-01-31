extends Node2D

@export var armas: Array[PackedScene]
var instanciated_armas: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for arma in armas:
		instanciated_armas.append(arma.instantiate())
	add_child(instanciated_armas[0])
	pass # Replace with function body.

# Called every frame. 'delta' is the elapssaed time since the previous frame.
func _process(delta: float) -> void:
	pass

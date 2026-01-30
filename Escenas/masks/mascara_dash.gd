class_name MascaraDash
extends Node2D

signal enable_dash
@export var _max_time: float
@export var _time_left: float = 1

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	activar_dash()
	pass # Replace with function body.
	
func _exit_tree() -> void:
	activar_dash()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _time_left == 0:
		get_parent().free_mask()
	pass

func activar_dash() -> void:
	print("activar_dash")
	enable_dash.emit()

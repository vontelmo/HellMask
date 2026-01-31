extends Node2D

signal mascara_dimension

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	activar_mascara()
	pass # Replace with function body.
	
func _exit_tree() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func activar_mascara() -> void:
	mascara_dimension.emit()

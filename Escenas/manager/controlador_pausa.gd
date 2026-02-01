extends Node
class_name Pausa

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pausa"):
		get_tree().paused = !get_tree().paused


func pausar():
	get_tree().paused = !get_tree().paused

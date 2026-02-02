extends Button

@export var manager : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(retry, 4)

func retry():
	
	get_tree().change_scene_to_packed(manager)

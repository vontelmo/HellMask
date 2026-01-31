extends Node2D 

@export var starter_room : PackedScene   

func _ready() -> void:
	_create_room.call_deferred()

func _create_room():
	var current_room = starter_room.instantiate()
	add_child(current_room)
	
	

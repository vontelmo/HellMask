extends Node2D 

@export var room_spawner : PackedScene   

func _ready() -> void:
	_create_room.call_deferred()

func _create_room():
	var current_room = room_spawner.instantiate()
	add_child(current_room)
	
	
	

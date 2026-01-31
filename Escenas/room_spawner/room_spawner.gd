extends Node2D

@export var rooms: Array[PackedScene]

func _ready() -> void:
	var index = randi() % len(rooms)
	var room = rooms[index].instantiate()
	add_child(room)

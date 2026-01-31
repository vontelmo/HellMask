extends Node2D

@export var rooms: Array[PackedScene]
@export var offset: Vector2 = Vector2(100, 0) # para spawnear a la derecha

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		var index = randi() % rooms.size()
		var room = rooms[index].instantiate()
		room.position = global_position + offset
		get_parent().add_child(room)

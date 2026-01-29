extends Node2D

@export var rooms: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index = randi() % len(rooms)
	var room = rooms[index].instantiate()
	add_child(room)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

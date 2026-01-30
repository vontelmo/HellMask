extends Area2D

class_name Door

@export var destination_level_tag : String
@export var destination_door_tag : String
@export var spaw_direction = "up"
@export var rooms: Array[PackedScene]

@onready var spawn = $Spawn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print(body.name)
		#NavigationManager.go_to_level(destination_door_tag,destination_level_tag)
		#var index = randi() % len(rooms)
		var room = rooms[0].instantiate()
		add_child(room)

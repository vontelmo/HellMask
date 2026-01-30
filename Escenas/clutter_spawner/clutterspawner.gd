extends Node2D

@export var clutterPool: Array[PackedScene]

func _ready():
	SpawnClutter()

func SpawnClutter() -> void:
	
	var scene: PackedScene = clutterPool.pick_random()
	var obstacle = scene.instantiate()

	obstacle.global_position = global_position

	get_parent().add_child.call_deferred(obstacle)

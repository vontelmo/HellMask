class_name Enemigo
extends CharacterBody2D

var player: CharacterBody2D
@export var speed : int
@export var health : int

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta):
	if not player:
		return

	var dir = (player.global_position - global_position).normalized()
	velocity = dir * speed
	move_and_slide()

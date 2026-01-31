class_name Arma_Enemigo
extends Node2D

@export var damage: int = 10
@export var fire_rate: float = 1.0   # disparos por segundo
@export var projectile_scene: PackedScene
@export var projectile_speed: float = 300.0

var _cooldown := 0.0

func _process(delta):
	if _cooldown > 0:
		_cooldown -= delta

func try_shoot(from_position: Vector2, direction: Vector2):
	if _cooldown > 0:
		return
		
	shoot(from_position, direction)
	_cooldown = 1.0 / fire_rate

func shoot(from_position: Vector2, direction: Vector2):
	if projectile_scene == null:
		return
		
	var bullet = projectile_scene.instantiate()
	bullet.global_position = from_position
	bullet.direction = direction
	
	bullet.speed = projectile_speed
	bullet.damage = damage
	
	get_tree().current_scene.add_child(bullet)
	print("disparop pew pew")

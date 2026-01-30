extends CharacterBody2D

class_name Player

var _velocidad = 300
@export var _health : float

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	# movimiento 
	if Input.is_action_pressed("derecha"):
		velocity.x += 1
	if Input.is_action_pressed("izquierda"):
		velocity.x -= 1
	if Input.is_action_pressed("abajo"):
		velocity.y += 1
	if Input.is_action_pressed("arriba"):
		velocity.y -= 1
	
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * _velocidad
		
	move_and_slide()

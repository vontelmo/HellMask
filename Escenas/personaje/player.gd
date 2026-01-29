extends CharacterBody2D


var _velocidad = 300


func _physics_process(delta: float) -> void:
	# movimiento 
	if Input.is_action_pressed("derecha"):
		velocity.x = _velocidad
	elif Input.is_action_pressed("izquierda"):
		velocity.x = -_velocidad
	elif Input.is_action_pressed("abajo"):
		velocity.y = _velocidad
	elif Input.is_action_pressed("arriba"):
		velocity.y = -_velocidad
	else:
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()

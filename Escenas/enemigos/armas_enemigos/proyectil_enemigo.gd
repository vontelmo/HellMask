extends Area2D

var direction: Vector2
var speed: float
var damage: int


func _physics_process(delta):
	global_position += direction * speed * delta
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()

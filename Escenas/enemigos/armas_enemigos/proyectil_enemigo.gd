extends Node2D

@onready var hurtbox := $Hurtbox

var direction: Vector2
var speed: float
var damage: int

func _ready() -> void:
	hurtbox.body_entered.connect(_on_body_entered)
	rotation = direction.angle()

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		body._take_damage(damage)
		queue_free()
	
	if body is TileMapLayer:
		queue_free()
	if body.is_in_group("obstacles"):
		queue_free()

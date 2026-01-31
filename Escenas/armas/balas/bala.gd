extends Node2D

@onready var hurtbox := $Hurtbox

var direction: Vector2
var speed: float
var damage: int

func _ready() -> void:
	hurtbox.body_entered.connect(_on_hurtbox_body_entered)
	rotation = direction.angle()

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_hurtbox_body_entered(body: Node):
	if body.is_in_group("enemies"):
		body._take_damage(damage)
		print("hago dano")
		queue_free()
	if body.is_in_group("obstacles"):
		queue_free()

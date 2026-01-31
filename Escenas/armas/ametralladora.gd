extends Arma

@export var projectile_scene: PackedScene
@export var bullet_speed: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack():
	if projectile_scene == null:
		return
		
	var bullet = projectile_scene.instantiate()
	bullet.global_position = global_position
	bullet.direction = Vector2.RIGHT.rotated(get_parent().global_rotation)
	bullet.speed = bullet_speed
	bullet.damage = dmg
	
	get_tree().current_scene.add_child(bullet)
	#print("disparop pew pew")
	super.attack()

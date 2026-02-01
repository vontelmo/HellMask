extends Arma

@export var projectile_scene: PackedScene
@export var bullet_speed: int

@export var bullet_count := 30
@export var spread_angle_deg := 90.0

func attack():
	if projectile_scene == null:
		return

	var base_rotation = get_parent().global_rotation
	var spread_rad := deg_to_rad(spread_angle_deg)

	# Caso especial: 1 bala
	if bullet_count == 1:
		_spawn_bullet(base_rotation)
	else:
		for i in bullet_count:
			var t := float(i) / float(bullet_count - 1) # 0 → 1
			var offset = lerp(-spread_rad / 2, spread_rad / 2, t)
			_spawn_bullet(base_rotation + offset)

	super.attack()
	
func _spawn_bullet(rotation_angle: float):
	var bullet = projectile_scene.instantiate()
	bullet.global_position = global_position
	bullet.direction = Vector2.RIGHT.rotated(rotation_angle)
	bullet.speed = bullet_speed
	bullet.damage = dmg
	get_tree().current_scene.add_child(bullet)

extends Marker2D

@export var enemy_pool: Array[PackedScene]
@export var enemy_count: int = 10
@export var spawn_interval: float = 0.2

# Separación mínima entre enemigos (px)
@export var min_sep: float = 24.0

# Qué tan lejos como máximo puede caer del marker (px)
@export var jitter_radius: float = 64.0

# Cuántos intentos antes de rendirse y spawnear igual
@export var max_tries: int = 12

var spawned := 0
var _used_positions: Array[Vector2] = []

func _ready() -> void:
	# para que pick_random sea realmente aleatorio en cada run
	randomize()

	await get_tree().process_frame
	spawn_loop()

func spawn_loop() -> void:
	while spawned < enemy_count:
		_spawn_enemy()
		spawned += 1
		await get_tree().create_timer(spawn_interval).timeout

func _spawn_enemy() -> void:
	if enemy_pool.is_empty():
		push_warning("enemy_pool está vacío")
		return

	var scene: PackedScene = enemy_pool.pick_random()
	var enemy := scene.instantiate()

	# posición base del marker (local)
	var base_pos := position
	enemy.position = _get_spawn_pos_with_spacing(base_pos)

	get_parent().add_child.call_deferred(enemy)

func _get_spawn_pos_with_spacing(base_pos: Vector2) -> Vector2:
	var chosen := base_pos
	var tries := 0

	while tries < max_tries:
		# offset aleatorio dentro de un círculo
		var angle := randf() * TAU
		var r := sqrt(randf()) * jitter_radius
		var candidate := base_pos + Vector2(cos(angle), sin(angle)) * r

		# chequear distancia mínima con los ya spawneados
		var ok := true
		for p in _used_positions:
			if p.distance_to(candidate) < min_sep:
				ok = false
				break

		if ok:
			chosen = candidate
			break

		tries += 1

	_used_positions.append(chosen)
	return chosen

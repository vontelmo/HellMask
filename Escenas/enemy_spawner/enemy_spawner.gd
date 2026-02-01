extends Marker2D

@export var enemy_pool: Array[PackedScene]
@export var enemy_count: int
@export var spawn_interval: float 

var spawned = 0

func _ready():
	await get_tree().process_frame
	spawn_loop()


func spawn_loop() -> void:
	while spawned < enemy_count:
		_spawn_enemy()
		spawned += 1
		await get_tree().create_timer(spawn_interval).timeout
		
func _spawn_enemy() -> void:
	
	var scene: PackedScene = enemy_pool.pick_random()
	var enemy = scene.instantiate()

	enemy.position = position
	
	get_parent().add_child.call_deferred(enemy)
	

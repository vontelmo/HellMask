extends CharacterBody2D

class_name Enemigo

#var player: CharacterBody2D
#@export var speed : int
@export var health : int
@export var weapon : PackedScene
@export var damage : float
@export var attack_speed : float
@export var range : float

var is_alive


@export var speed := 120
@onready var agent := $NavigationAgent2D
@onready var player := get_tree().get_first_node_in_group("player")

var last_target_pos: Vector2

func _ready():
	agent.radius = 20.0  # ejemplo
	
	agent.target_position = player.global_position
	agent.avoidance_enabled = true
	agent.max_neighbors = 10
	agent.time_horizon = 1.0
	Roomspawncontroller.update_enemigo_vivo()

func _process(delta: float) -> void:
	if health == 0:
		is_alive = false
		_death()

	
func _physics_process(delta):
	if player.global_position.distance_to(last_target_pos) > 16:
		agent.target_position = player.global_position
		last_target_pos = player.global_position
		
	var next_pos = agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()

	velocity = direction * speed
	move_and_slide()

func _take_damage(amount):
	health -= amount
	if health<= 0:
		_death()

func attack():
	if player == null or weapon == null:
		#print("no hay nadaaaa")
		return
	if player.global_position.distance_to(last_target_pos) > range:
		var dir = (player.global_position - global_position).normalized()
		weapon.try_shoot(global_position, dir)
		#print("disparo desde enemigo")

func _death():
	if not is_alive:
		Roomspawncontroller.update_enemigo_muerto()
		if is_inside_tree():
			print("estoy morido")
			get_parent().remove_child(self)

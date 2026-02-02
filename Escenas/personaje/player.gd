extends CharacterBody2D
class_name Player

@export var escena_muerte: PackedScene
@export var masks: Array[PackedScene] 
var instanciated_masks: Array[Node]
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var dash = false
var _is_dashing = false
var dash_dir
var _velocidad = 300
var is_alive = true
@export var _health : float

func _ready() -> void:
	for mask in masks:
		instanciated_masks.append(mask.instantiate())
	instanciated_masks[1].enable_dash.connect(_activar_dash)
	
func _process(delta: float) -> void:
	if _health <= 0:
		is_alive = false

func _physics_process(delta: float) -> void:
	# movimiento 
	if Input.is_action_pressed("derecha"):
		velocity.x = _velocidad
		anim.play("default")
		
	elif Input.is_action_pressed("izquierda"):
		velocity.x = -_velocidad
		anim.play("default")
	elif Input.is_action_pressed("abajo"):
		velocity.y = _velocidad
		anim.play("default")
	elif Input.is_action_pressed("arriba"):
		velocity.y = -_velocidad
		anim.play("default")
	elif _is_dashing:
		var dash_speed := 600.0
		velocity = dash_speed * dash_dir
	else:
		$AnimatedSprite2D.frame = 0
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("m_dimension"):
	#	free_mask()
	#	add_child.call_deferred(instanciated_masks[0])
	if event.is_action_pressed("m_dash"):
		free_mask()
		add_child.call_deferred(instanciated_masks[1])
	elif event.is_action_pressed("m_fuerza"):
		free_mask()
		add_child.call_deferred(instanciated_masks[2])
	elif Input.is_action_just_pressed("dash"):
		if dash:
			dashear()
		
func free_mask():
	for mask in instanciated_masks:
		if mask.is_inside_tree():
			remove_child(mask)
			
func _activar_dash():
	dash = !dash

func dashear():
	dash_dir = (get_global_mouse_position() - global_position).normalized()
	_is_dashing = true
	$Timer.start()

func _on_timer_timeout() -> void:
	_is_dashing = false
	pass # Replace with function body.

func _take_damage(damage):
	print("me hacen dano:", damage)
	_health -= damage
	if _health <= 0:
		_death()
	
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func actualizar_flip(direccion: Vector2) -> void:
	sprite.flip_h = direccion.x < 0

func _death():
	if not is_alive:
		if is_inside_tree():
			print("estoy morido")
			get_tree().change_scene_to_packed(escena_muerte)

			

class_name Arma
extends Node2D

@export var cargas_max: int
@export var dmg: int
@export var cooldown: float
@export var charging_time: float
var _is_charging = false
var cooling = false
var cargas = 0

func _ready() -> void:
	cargas = cargas_max

func _process(delta: float) -> void:
	pass

func attack() -> void:
	if _is_charging || cooling:
		return
	cargas -= 1
	if cargas <= 0:
		call_deferred("cargar")
	else:
		start_cooldown()
	pass

func start_cooldown():
	$Timer.start(cooldown)
	print("cooling")
	pass

func cargar():
	_is_charging = true
	$Timer.start(charging_time)
	print("cargando")
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("atacar"):
		if !_is_charging:
			attack()
		
func _on_timer_timeout() -> void:
	if cooling:
		cooling = false
		print("termino cooling")
	if _is_charging:
		cargas = cargas_max
		_is_charging = false
		print("termino de cargar")
	pass # Replace with function body.

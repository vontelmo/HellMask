extends Arma

@onready var hurtbox := $Hurtbox

@export var swing_angle := PI * 0.75
@export var swing_time := 0.15

const BASE_ROTATION := 0  # vertical (ajustá si tu sprite apunta distinto)
var attacking := false

func _ready() -> void:
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	rotation = BASE_ROTATION

func _process(delta: float) -> void:
	super._process(delta)

func attack() -> void:
	# NO llamamos super.attack() acá
	if attacking:
		return

	attacking = true
	print("whoosh")

	hurtbox.monitoring = true

	rotation = BASE_ROTATION - swing_angle / 2

	var tween := create_tween()
	tween.tween_property(
		self,
		"rotation",
		BASE_ROTATION + swing_angle / 2,
		swing_time
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.finished.connect(_end_attack)
	super.attack()

func _end_attack():
	hurtbox.monitoring = false
	rotation = BASE_ROTATION
	attacking = false

func _on_hurtbox_area_entered(area: Area2D):
	if area.is_in_group("enemies"):
		area.get_parent()._take_damage(dmg)

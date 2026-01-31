extends Arma

@onready var hurtbox := $Hurtbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cargas = 1
	dmg = 200
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_hurtbox_area_entered(area: Area2D):
	if area.is_in_group("enemies"):
		print(area)
		area.get_parent()._take_damage(dmg)

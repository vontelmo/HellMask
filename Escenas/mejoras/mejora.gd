extends Button
class_name UpgradeButton

func _ready():
	pass

func _on_focus_entered():
	scale = Vector2(1.2, 1.2)
	modulate = Color(1.2, 1.2, 1.2)

func _on_focus_exited():
	scale = Vector2.ONE
	modulate = Color.WHITE

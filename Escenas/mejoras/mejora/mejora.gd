extends Button
class_name UpgradeButton

@export var titulo: String = "MEJORA"

func _ready():
	actualizar_ui()
	pass
	
func actualizar_ui():
	text = titulo

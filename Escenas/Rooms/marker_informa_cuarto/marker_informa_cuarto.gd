extends Node2D

func _ready() -> void:
	var parent = get_parent()
	if parent:
		Roomspawncontroller.report_marker_parent(parent)
	else:
		push_warning("Marker creado sin padre")

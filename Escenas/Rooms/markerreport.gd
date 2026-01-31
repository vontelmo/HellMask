extends Marker2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("marcador de borrar cuarto funcionando")
	Roomspawncontroller.report_marker_position(global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

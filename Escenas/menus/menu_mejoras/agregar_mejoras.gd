extends HBoxContainer

@export var mejoras : Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(3):
		var curr_mejora = mejoras.pick_random().instantiate()
		add_child(curr_mejora)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

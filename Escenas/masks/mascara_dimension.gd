extends Node2D

signal cambio_dimension
@export var _max_time: float
@export var _time_left: float = 1000000000000000000

func _ready() -> void:
	print("hola soy virgen")

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	print("enter kmnd,fgjkdshfn")
	cambiar_dimension()
	pass # Replace with function body.
	
func _exit_tree() -> void:
	print("exit asjdnaljksdhlgdfl")
	#cambiar_dimension()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _time_left == 0:
		get_parent().free_mask()
	pass

func cambiar_dimension() -> void:
	Roomspawncontroller.toggle_dimension()
	cambio_dimension.emit()

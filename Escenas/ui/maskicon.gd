extends TextureRect

@export var mask_icons := {
	"dim": preload("res://Escenas/sprites/Máscaras sueltas (por si necesitan)/mascara11_1.PNG"),
	"dash": preload("res://Escenas/sprites/Máscaras sueltas (por si necesitan)/mascara21_1.PNG"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("m_dash"):
		texture = mask_icons["dash"]
	elif event.is_action_pressed("m_fuerza"):
		pass
	elif Input.is_action_just_pressed("m_dimension"):
		texture = mask_icons["dim"]
		

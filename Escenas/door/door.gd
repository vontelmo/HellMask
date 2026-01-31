extends Area2D
class_name Door

@export var destination_level_tag: String
@export var destination_door_tag: String
@export var spawn_direction := "up"
@export var rooms: Array[PackedScene]

@onready var spawn: Node2D = $Spawn

var spawncounter = 1
 

func _ready() -> void:
	print("hola soy una puerta muy ")
	Roomspawncontroller.register_door(self)

func _on_body_entered(body: Node2D) -> void:
	print("HOLAAAA - Entró:", body.name, "Clase:", body.get_class())
	
	Roomspawncontroller.on_player_touch_x(global_position)
	print("sjndfkjnds")
		

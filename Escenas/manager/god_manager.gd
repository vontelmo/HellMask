extends Node2D 

@onready var starter_room = preload("res://Escenas/Rooms/starterroom/starterroom.tscn")

func _ready() -> void:
	_create_room.call_deferred()

func _create_room():
	# Solo crear si aún no hay una room actual
	if Roomspawncontroller.room_actual:
		print("Starter room ya creada, no se instancia de nuevo")
		return

	var current_room = starter_room.instantiate()
	Roomspawncontroller.avisarstarterroon(current_room)
	add_child(current_room)
	Roomspawncontroller.room_actual = current_room
	print("Starter room creada:", current_room.name)

	

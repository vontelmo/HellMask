extends Node

const scene_room_3 = preload("res://Escenas/Rooms/room_3.tscn")
const scene_room_1 = preload("res://Escenas/Rooms/room_1.tscn")

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	match level_tag:
		"room_3":
			scene_to_load = scene_room_3
		"room_1":
			scene_to_load = scene_room_1
		
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)

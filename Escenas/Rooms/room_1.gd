extends Node2D

@onready var tiles_obs1 := $"Obstaculos 1" 
@onready var tiles_obs2 := $"Obstaculos 2" 

@onready var nav_region1 := $NavigationRegion2D
@onready var nav_region2 := $NavigationRegion2D2


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("m_dimension"):
		tiles_obs1.enabled = !tiles_obs1.enabled
		tiles_obs2.enabled = !tiles_obs2.enabled
		nav_region1.enabled = !nav_region1.enabled
		nav_region2.enabled = !nav_region2.enabled
		

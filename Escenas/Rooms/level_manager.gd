extends Node

@onready  var region_dim_1 = $NavigationRegion2D
@onready var region_dim_2 = $NavigationRegion2DB

func _ready():
	var r1 = get_tree().get_first_node_in_group("nav_dim_1")
	var r2 = get_tree().get_first_node_in_group("nav_dim_2")

	print("Buscadas por grupo:", r1, r2)

	Roomspawncontroller.registrar_regiones(r1, r2)

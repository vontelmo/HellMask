extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	pass
#el problema aca es que primero agarra la barrera y despues borra el cuarto anterior, debe ser al revez
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("jugador esta entrando a cuarto nuevo")
		Roomspawncontroller.on_player_entra_cuarto_nuevo_delete()
		var barrera = get_tree().get_first_node_in_group("sprite_barrera_entrada")

		Roomspawncontroller.on_player_entra_cuarto_nuevo_cerrar_barrera(barrera)

extends Node
# (script del marker/Area2D; mantené el nombre de nodo que usás)
# Nota: el proyecto ya usa Roomspawncontroller.on_player_entra_cuarto_nuevo(...)
# por eso uso Roomspawncontroller.cerrar_barrera para cerrar inmediatamente.
var menu_mejora: PackedScene = preload("res://Escenas/menus/menu_mejoras/menu_mejoras.tscn")



func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass




# Al entrar: cerramos la barrera INMEDIATAMENTE y luego avisamos al controlador
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("Jugador entrando a cuarto nuevo (marker)")
		ControladorPausa.toggle_pause()
		var barrera := get_tree().get_first_node_in_group("sprite_barrera_entrada")
		
		
		var menu = menu_mejora.instantiate()
		add_child(menu)
		
		# 1) Forzar cierre inmediato sobre la barrera encontrada (si es válida)
		if barrera and is_instance_valid(barrera):
			var cerrado_hecho := false
			# intentar propiedad 'enabled' (tu código actual la usa)
			if "enabled" in barrera:
				barrera.enabled = Roomspawncontroller.cerrar_barrera
				cerrado_hecho = true
			# fallback a visible si existe
			if not cerrado_hecho and barrera.has_method("set_visible"):
				barrera.visible = not Roomspawncontroller.cerrar_barrera
				cerrado_hecho = true
			# último recurso: desactivar procesamiento físico
			if not cerrado_hecho and barrera.has_method("set_physics_process"):
				barrera.set_physics_process(false)
				cerrado_hecho = true

			print("Barrera cerrada inmediatadsmente ->", cerrado_hecho)
		else:
			push_warning("No se encontró barrera válida para cerrar inmediatamente")

		# 2) Llamar al controlador (que después borrará la room_previous)
		Roomspawncontroller.on_player_entra_cuarto_nuevo(barrera)

		# 3) Evitar retriggers: desactivar la colisión del marker si existe
		if has_node("CollisionShape2D"):
			$CollisionShape2D.disabled = true

# Si querés, podés dejar _on_body_exited vacío para no volver a llamar:
func _on_body_exited(body: Node2D) -> void:
	queue_free()
	pass

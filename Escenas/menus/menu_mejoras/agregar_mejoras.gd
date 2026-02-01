extends HBoxContainer

@export var mejoras: Array[PackedScene]
@export var cantidad: int = 3

func _ready() -> void:
	if mejoras.is_empty():
		return

	# no podés pedir más únicas que las que existen
	var n = min(cantidad, mejoras.size())

	# copia + shuffle para sacar sin repetir
	var pool: Array[PackedScene] = mejoras.duplicate()
	pool.shuffle()

	for i in range(n):
		var curr_mejora = pool[i].instantiate()
		add_child(curr_mejora)

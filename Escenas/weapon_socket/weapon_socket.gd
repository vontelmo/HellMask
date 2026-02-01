extends Node2D

@export var armas: Array[PackedScene]
@export var radius := 32.0

var instanciated_armas: Array[Node2D] = []
var arma_actual: Node2D = null
var indice_actual := -1

func _ready() -> void:
	for arma in armas:
		instanciated_armas.append(arma.instantiate())

	# arma inicial
	cambiar_arma(0)

func _process(delta: float) -> void:
	var dir := (get_global_mouse_position() - global_position).normalized()
	position = dir * radius
	rotation = dir.angle()

func cambiar_arma(nueva_arma: int) -> void:
	if nueva_arma < 0 or nueva_arma >= instanciated_armas.size():
		return

	# sacar la anterior si realmente está como hija
	if arma_actual != null and arma_actual.get_parent() == self:
		remove_child(arma_actual)

	# poner la nueva
	arma_actual = instanciated_armas[nueva_arma]
	indice_actual = nueva_arma
	add_child(arma_actual)

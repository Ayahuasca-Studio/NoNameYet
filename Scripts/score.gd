extends Control

var puntaje_total: int = 0
@onready var label_score: Label = $Label # Si tienes un Label hijo para mostrarlo

func _ready() -> void:
	add_to_group("score_manager")
	actualizar_texto()

func sumar_puntos(cantidad: int) -> void:
	puntaje_total += cantidad
	print("✨ Puntos obtenidos: +", cantidad, " | Total: ", puntaje_total)
	actualizar_texto()

func restar_puntos(cantidad: int) -> void:
	puntaje_total = clampi(puntaje_total - cantidad, 0, 999999)
	actualizar_texto()

func actualizar_texto() -> void:
	if label_score:
		label_score.text = "Puntos: %d" % puntaje_total

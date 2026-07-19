extends Node2D

var estres_planta: float = 0.0
var max_estres: float = 100.0
var juego_terminado: bool = false
@onready var interfaz = $Interfaz

func _ready():
	if TransitionManager.current_spawn_point != "":
		# Buscamos el Marker2D que coincida con ese nombre
		var spawn_node = get_node_or_null(TransitionManager.current_spawn_point)
		
		if spawn_node:
			$Jugador.global_position = spawn_node.global_position

func modificar_estres(cantidad: float) -> void:
	if juego_terminado:
		return
	# Modificamos el valor y usamos 'clampf' para asegurarnos de que no baje de 0 ni suba de 100
	estres_planta = clampf(estres_planta + cantidad, 0.0, max_estres)
	#control de interfaz grafica
	if interfaz:
		interfaz.actualizar_estres(estres_planta)
	# Condición de derrota
	if estres_planta >= max_estres:
		derrota_juego()



func derrota_juego() -> void:
	juego_terminado = true
	print("\n💥💥 GAME OVER 💥💥")
	print("El sabotaje del mentor destruyó los servidores principales de la planta.")
	print("El nivel de estrés superó el 100%. El sistema colapsó.")
	# Pausamos el juego por completo para detener los movimientos
	get_tree().change_scene_to_file("res://interfaces/game_over.tscn")

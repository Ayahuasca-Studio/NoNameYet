extends Node2D

# Variables globales de control de la partida
var estres_planta: float = 0.0
var max_estres: float = 100.0
var juego_terminado: bool = false

# Un temporizador interno para no saturar la consola imprimiendo a cada milisegundo
var tiempo_impresion: float = 0.0

func _ready() -> void:
	print(" SISTEMA DE MONITOREO ACTIVADO: Mantén el estrés de la planta bajo control.")

func _process(delta: float) -> void:
	if juego_terminado:
		return
		
	# Controlar el tiempo para imprimir el estado del panel de control cada 1.5 segundos
	tiempo_impresion += delta
	if tiempo_impresion >= 1.5:
		imprimir_panel_estado()
		tiempo_impresion = 0.0

# Esta función la llamará la máquina cuando esté dañada (para subir) 
# o cuando sea reparada con éxito (para bajar)
func modificar_estres(cantidad: float) -> void:
	if juego_terminado:
		return
		
	# Modificamos el valor y usamos 'clampf' para asegurarnos de que no baje de 0 ni suba de 100
	estres_planta = clampf(estres_planta + cantidad, 0.0, max_estres)
	
	# Condición de derrota
	if estres_planta >= max_estres:
		derrota_juego()

func imprimir_panel_estado() -> void:
	# Creamos una pequeña barra visual en texto para la consola
	var barras = ""
	var bloques_llenos = int(estres_planta / 10)
	for i in range(10):
		if i < bloques_llenos:
			barras += "█"
		else:
			barras += "░"
			
	print("\n---  PANEL DE CONTROL EN TIEMPO REAL ---")
	print("Nivel de Estrés de la Planta: [", barras, "] ", int(estres_planta), "%")
	if estres_planta > 70:
		print("¡CRÍTICO! ¡Evacuación inminente! Arregla las máquinas rápido.")
	print("------------------------------------------")

func derrota_juego() -> void:
	juego_terminado = true
	print("\n💥💥 GAME OVER 💥💥")
	print("El sabotaje del mentor destruyó los servidores principales de la planta.")
	print("El nivel de estrés superó el 100%. El sistema colapsó.")
	# Pausamos el juego por completo para detener los movimientos
	get_tree().paused = true

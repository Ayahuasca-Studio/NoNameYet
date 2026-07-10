extends Control # Si tu nodo MainMenu es Node2D, cambia esto a "extends Node2D"

# 1. Actualizamos las rutas agregando CanvasLayer al inicio
@onready var btn_jugar = $CanvasLayer/Play     # Usé los nombres de tu captura anterior
@onready var btn_opciones = $CanvasLayer/Options
@onready var btn_salir = $CanvasLayer/Exit

func _ready():
	# Conectar las señales de click
	btn_jugar.pressed.connect(_on_btn_jugar_pressed)
	btn_opciones.pressed.connect(_on_btn_opciones_pressed)
	btn_salir.pressed.connect(_on_btn_salir_pressed)
	


# --- LÓGICA DE CLICKS ---
func _on_btn_jugar_pressed():
	# Cambia "res://planta_baja.tscn" por la ruta real de tu escena de juego
	get_tree().change_scene_to_file("res://planta_baja.tscn")

func _on_btn_opciones_pressed():
	print("Abrir panel de opciones (pendiente de implementar)")

func _on_btn_salir_pressed():
	get_tree().quit()

extends Control

# Referencia a tu reproductor de video en el árbol de nodos
@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

# Te permite seleccionar cualquier archivo .tscn directamente desde el Inspector de Godot
@export_file("*.tscn") var siguiente_escena: String

func _ready() -> void:
	video_player.finished.connect(_on_video_terminado)
	video_player.play()

# OPCIONAL: Tecla de saltar cinemática (Enter / Espacio)
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print("⏭️ Saltando cinemática...")
		_on_video_terminado()

func _on_video_terminado() -> void:
	if siguiente_escena != "":
		print("🎬 Cinemática terminada. Cargando: ", siguiente_escena)
		get_tree().change_scene_to_file(siguiente_escena)
	else:
		print("⚠️ ¡ATENCIÓN! No asignaste la 'Siguiente Escena' en el Inspector del nodo Cinematic1.")
extends CanvasLayer

@onready var color_rect = $ColorRect
var current_spawn_point: String = "" # Aquí guardaremos el dato

func _ready():
	color_rect.modulate.a = 0
	hide()

# Añadimos el nuevo parámetro
func change_scene(target_scene: String, spawn_point: String):
	current_spawn_point = spawn_point # Guardamos el destino
	show()
	get_tree().paused = true 
	
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.5) 
	await tween.finished 
	
	get_tree().change_scene_to_file(target_scene)
	
	var tween_out = create_tween()
	tween_out.tween_property(color_rect, "modulate:a", 0.0, 0.5)
	await tween_out.finished
	
	get_tree().paused = false 
	hide()
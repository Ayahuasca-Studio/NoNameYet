extends CanvasLayer


func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://Niveles/main_menu.tscn")
	
	


func _on_salir_pressed() -> void:
	get_tree().quit()

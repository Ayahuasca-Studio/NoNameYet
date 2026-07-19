extends CanvasLayer


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Niveles/main_menu.tscn")
	


func _on_texture_button_2_pressed() -> void:
	get_tree().quit()

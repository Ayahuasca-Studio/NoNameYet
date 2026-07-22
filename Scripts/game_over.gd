extends CanvasLayer


func _ready() -> void:
	AudioConfig.play_sfx(AudioConfig.SFX_GAME_OVER)


func _on_texture_button_pressed() -> void:
	AudioConfig.play_sfx(AudioConfig.SFX_CLICK)
	get_tree().change_scene_to_file("res://Niveles/main_menu.tscn")



func _on_texture_button_2_pressed() -> void:
	AudioConfig.play_sfx(AudioConfig.SFX_CLICK)
	get_tree().quit()

extends Node

# Variable global que guarda si el sonido está activado o no
var sound_enabled: bool = true

func set_sound(enabled: bool) -> void:
	sound_enabled = enabled
	
	# Mutea o desmutea el bus principal de audio ("Master") en Godot
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus_index, not sound_enabled)
extends Node2D

func _ready():
	if TransitionManager.current_spawn_point != "":
		# Buscamos el Marker2D que coincida con ese nombre
		var spawn_node = get_node_or_null(TransitionManager.current_spawn_point)
		
		if spawn_node:
			$Jugador.global_position = spawn_node.global_position

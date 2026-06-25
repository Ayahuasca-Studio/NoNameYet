extends Area2D

@export var next_scene: String 
@export var target_spawn_point: String # Nuevo: Aquí pondrás "SpawnStairs" o "SpawnElevator"

func _on_body_entered(body):
	if body.name == "Jugador":
		if next_scene != "" and target_spawn_point != "":
			# Enviamos la escena y el punto de aparición al Manager
			TransitionManager.change_scene(next_scene, target_spawn_point)
		else:
			if next_scene == "":
				print("Error: Falta configurar la escena de destino.")
			if target_spawn_point == "":
				print("Error: Falta configurar el punto de aparición.")

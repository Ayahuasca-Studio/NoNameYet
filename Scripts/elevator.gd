extends Area2D

# Al usar @export_file("*.tscn"), Godot te mostrará un buscador de archivos en el Inspector
@export_file("*.tscn") var next_scene: String 
@export var target_spawn_point: String # Aquí pondrás "SpawnStairs" o "SpawnElevator"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		if next_scene != "" and target_spawn_point != "":
			# Enviamos la escena y el punto de aparición al Manager
			TransitionManager.change_scene(next_scene, target_spawn_point)
		else:
			if next_scene == "":
				print("Error: Falta configurar la escena de destino en el Inspector.")
			if target_spawn_point == "":
				print("Error: Falta configurar el punto de aparición en el Inspector.")
extends Area2D

enum Dirección { ABAJO, ARRIBA, DERECHA, IZQUIERDA }

@export var direccion_salida: Dirección = Dirección.ABAJO

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		var dir_jugador: Vector2 = body.velocity.normalized()
		var dir_objetivo: Vector2 = _obtener_vector_direccion()
		
		if dir_jugador.dot(dir_objetivo) > 0.5:
			quitar_epp(body)

func _obtener_vector_direccion() -> Vector2:
	match direccion_salida:
		Dirección.ABAJO:
			return Vector2.DOWN
		Dirección.ARRIBA:
			return Vector2.UP
		Dirección.DERECHA:
			return Vector2.RIGHT
		Dirección.IZQUIERDA:
			return Vector2.LEFT
		_:
			return Vector2.DOWN

func quitar_epp(jugador: Node2D) -> void:
	if "epp_equipado" in jugador:
		# 1. Desequipamos todos los items en el jugador
		for item in jugador.epp_equipado.keys():
			jugador.epp_equipado[item] = false
		
		print("EPP quitado al salir:", jugador.epp_equipado)
		
		# 2. Notificamos a la Interfaz de Usuario para actualizar el HUD
		get_tree().call_group("interfaz", "actualizar_ranuras_epp", jugador.epp_equipado)
		
		# 3. Sonido opcional
		if AudioConfig:
			AudioConfig.play_sfx(AudioConfig.SFX_SWITCH)
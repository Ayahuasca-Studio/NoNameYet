extends Area2D

@export var maquina: Area2D
var jugador_dentro:Node2D = null


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		print("El jugador toco el control")
		jugador_dentro = body



func _input(event: InputEvent) -> void:
	if !maquina:
		return
	if jugador_dentro != null and Input.is_action_just_pressed("ui_accept"):
		maquina.cambioControl()
	


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Jugador":
		print("El jugador dejo el control")
		jugador_dentro = null

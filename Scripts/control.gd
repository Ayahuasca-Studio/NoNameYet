extends Area2D

@export var maquina: Area2D
var jugador_dentro:Node2D = null
@onready var estado: Label = $Estado

func _ready() -> void:
	estado.visible = false
	estado.text = "Apagar"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		print("El jugador toco el control")
		jugador_dentro = body
		estado.visible = true


func _input(event: InputEvent) -> void:
	if !maquina:
		return
	if jugador_dentro != null and Input.is_action_just_pressed("ui_accept"):
		AudioConfig.play_sfx(AudioConfig.SFX_SWITCH)
		maquina.cambioControl()
		cambiarTexto()
	

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Jugador":
		print("El jugador dejo el control")
		jugador_dentro = null
		estado.visible = false
		

func cambiarTexto() -> void:
	if estado.text=="Apagar":
		estado.text="Encender"
	else:
		estado.text="Apagar"

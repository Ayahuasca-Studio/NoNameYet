extends Area2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer
# Estados de la caldera
enum Estados {Bien, Roto}
var estada_actual:Estados = Estados.Bien
#Permiso para reparar
var control:bool = false
# VARIABLE: Guarda si el jugador está dentro del rango de la máquina
var jugador_en_rango: Node2D = null

var epp_req: int = 1;

func cambioControl () -> void:
	control = !control
	print("Cambio el control")


#--Control de la cercania del jugaro--
func _on_body_entered(body: Node2D) -> void:
	if body.name=="Jugador":
		jugador_en_rango = body
		print("El jugador toco el transformador")

func _on_body_exited(body: Node2D) -> void:
	if body.name=="Jugador":
		jugador_en_rango = null
		print("El jugador dejo el transformador")

func _input(event: InputEvent) -> void:
	# Si el jugador está cerca Y presiona la BARRA ESPACIADORA (ui_accept es espacio/enter por defecto)
	if jugador_en_rango != null and Input.is_action_just_pressed("ui_accept") and control:
		intentar_reparar()

func intentar_reparar()->void:
	if not jugador_en_rango:
		return
	var epp = jugador_en_rango.epp_equipado[epp_req]
	
	if epp:
		AudioConfig.play_sfx(AudioConfig.SFX_REPAIR_SUCCESS)
		estada_actual=Estados.Bien
		actualizar_visualizacion()
		print("Se reparo")
		var mundo = owner
		if mundo and mundo.has_method("modificar_estres"):
			mundo.modificar_estres(-25.0)

	else:
		AudioConfig.play_sfx(AudioConfig.SFX_REPAIR_FAIL)
		jugador_en_rango.recibir_danio(2)
		print("No se reparo")
	


func _on_timer_timeout() -> void:
	if estada_actual != Estados.Bien:
		return
	print("Por dañar transformador")
	var nueva_falla = 1
	estada_actual = nueva_falla as Estados
	actualizar_visualizacion()
	AudioConfig.play_sfx(AudioConfig.SFX_MACHINE_BREAK)
	print("dañar transformador")
	timer.wait_time = randf_range(15.0, 20.0)
	timer.start()
	print("reinicio reloj transformador")


func _process(delta: float) -> void:
	if estada_actual != Estados.Bien:
		# Si la máquina tiene una falla, le pide al escenario principal (Mundo) 
		# que sume estrés a la planta. Multiplicamos por delta para que sea constante.
		var mundo = owner
		if mundo and mundo.has_method("modificar_estres"):
			mundo.modificar_estres(2.0 * delta)

func actualizar_visualizacion() -> void:
	match estada_actual:
		Estados.Bien:
			sprite.modulate = Color.WHITE
			print("Transformador operando con normalidad.")
		Estados.Roto:
			sprite.modulate = Color.RED
			print("¡ALERTA! Se requiere Reparacion.")

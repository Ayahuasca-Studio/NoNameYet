extends Area2D

# --- SEÑAL PARA AVISAR AL CONTROL QUE SE REPARÓ ---
signal reparada

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

# Estados del transformador
enum Estados {Bien, Roto}
var estada_actual: Estados = Estados.Bien

# Permiso para reparar (y estado de encendido)
var control: bool = false

# VARIABLE: Guarda si el jugador está dentro del rango de la máquina
var jugador_en_rango: Node2D = null
var epp_req: int = 1

# --- NUEVAS VARIABLES DE PUNTAJE ---
@export var puntos_ganados: int = 150 # Más puntos por ser un transformador
var generando_puntos: bool = false

func _ready() -> void:
	# Evaluamos el estado inicial apenas cargue el nivel
	evaluar_puntos()

func cambioControl() -> void:
	control = !control
	print("Cambió el control del transformador a: ", control)
	# Evaluamos puntos al encender o apagar
	evaluar_puntos()

#--Control de la cercanía del jugador--
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jugador":
		jugador_en_rango = body
		print("El jugador tocó el transformador")

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Jugador":
		jugador_en_rango = null
		print("El jugador dejó el transformador")

func _input(event: InputEvent) -> void:
	# Si el jugador está cerca Y presiona la BARRA ESPACIADORA
	if jugador_en_rango != null and Input.is_action_just_pressed("ui_accept") and control:
		intentar_reparar()

func intentar_reparar() -> void:
	if not jugador_en_rango:
		return
	var epp = jugador_en_rango.epp_equipado[epp_req]
	
	if epp:
		AudioConfig.play_sfx(AudioConfig.SFX_REPAIR_SUCCESS)
		estada_actual = Estados.Bien
		
		# --- ENCENDIDO AUTOMÁTICO AL REPARAR ---
		control = false # Se enciende solo
		reparada.emit() # Le avisa al Control que cambie su texto a "Apagar"
		
		actualizar_visualizacion()
		print("Se reparó el transformador y se encendió automáticamente")
		
		# Evaluamos puntos al reparar con éxito:
		evaluar_puntos()
		
		var mundo = owner
		if mundo and mundo.has_method("modificar_estres"):
			mundo.modificar_estres(-25.0)
	else:
		AudioConfig.play_sfx(AudioConfig.SFX_REPAIR_FAIL)
		jugador_en_rango.recibir_danio(2)
		print("No se reparó el transformador")

func _on_timer_timeout() -> void:
	if estada_actual != Estados.Bien:
		return
	print("Por dañar transformador")
	var nueva_falla = 1
	estada_actual = nueva_falla as Estados
	actualizar_visualizacion()
	AudioConfig.play_sfx(AudioConfig.SFX_MACHINE_BREAK)
	print("Dañar transformador")
	
	# Evaluamos puntos al romperse:
	evaluar_puntos()
	
	timer.wait_time = randf_range(15.0, 20.0)
	timer.start()
	print("Reinicio reloj transformador")

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
			print("¡ALERTA! Se requiere reparación en el transformador.")

# --- FUNCIÓN DE PUNTAJE ---
func evaluar_puntos() -> void:
	# Si está operando bien Y además está encendido (control == false):
	if estada_actual == Estados.Bien and control == false:
		if not generando_puntos:
			generando_puntos = true
			get_tree().call_group("score_manager", "sumar_puntos", puntos_ganados)
	else:
		# Si se rompe o lo apagan desde la palanca, deja de generar puntos
		if generando_puntos:
			generando_puntos = false

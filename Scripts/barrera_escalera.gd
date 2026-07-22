extends StaticBody2D

# VARIABLES EXPORTADAS
@export var tiempo_espera_segundos: float = 60.0 # Tiempo total de bloqueo
@export var mensaje_bloqueo: String = "Escaleras bloqueadas. Esperando autorización..."
@export var mensaje_abierto: String = "¡Autorización recibida! Escaleras desbloqueadas."

# REFERENCIAS A NODOS
@onready var sprite: Sprite2D = $Sprite2D
@onready var colision: CollisionShape2D = $CollisionShape2D
@onready var timer_apertura: Timer = $TimerApertura


# ESTADOS
var esta_abierta: bool = false

func _ready() -> void:
	# 1. Configurar el Timer
	timer_apertura.wait_time = tiempo_espera_segundos
	timer_apertura.one_shot = true # Solo se ejecuta una vez
	timer_apertura.autostart = false # NO empieza solo, nosotros le diremos cuándo

	# 2. Asegurar estado inicial (cerrado)
	esta_abierta = false
	colision.disabled = false # Colisión activa (bloquea)
	# Aquí podrías poner el frame del sprite cerrado o la animación de "cerrado"
	# if anim_player: anim_player.play("cerrado")

	# 3. Conectar la señal del Timer para cuando termine
	timer_apertura.timeout.connect(_on_timer_apertura_timeout)

	# 4. (Opcional) Empezar el temporizador inmediatamente al cargar el nivel.
	# O mejor: llamar a esta función cuando el jugador interactúe con algo.
	iniciar_bloqueo()


# Función para arrancar el conteo (la puedes llamar desde el Mundo PB)
func iniciar_bloqueo() -> void:
	if not esta_abierta:
		timer_apertura.start()
		actualizar_interfaz_tiempo() # Avisar a la UI
		print("⏱️ Barrera: Conteo de ", tiempo_espera_segundos, " segundos iniciado.")


func _on_timer_apertura_timeout() -> void:
	abrir_barrera()


func abrir_barrera() -> void:
	if esta_abierta: return # Evitar doble ejecución

	esta_abierta = true
	print("🚨 Barrera: ¡Abriendo acceso a escaleras!")

	# 1. Efecto Visual
	# Opción A: Simplemente ocultar el sprite
	# sprite.visible = false
	# Opción B: Cambiar la textura a una puerta abierta (si tu compañero la hizo)
	# sprite.texture = load("res://path/to/puerta_abierta.png")
	# Opción C: Jugar una animación (la mejor opción)
	#if anim_player:
		#anim_player.play("abrir")
		#await anim_player.animation_finished # Esperar a que termine la anim
	
	# 2. Efecto Físico (¡CRÍTICO!)
	colision.disabled = true # Desactivar colisión (ya se puede pasar)
	visible = false

	# 3. Avisar a la Interfaz
	var interfaz = get_tree().get_first_node_in_group("Interfaz")
	if interfaz:
		interfaz.mostrar_notificacion(mensaje_abierto)
		interfaz.actualizar_tiempo_barrera(0) # Ocultar temporizador


# Función para que la interfaz pueda consultar cuánto tiempo falta
func obtener_tiempo_restante() -> float:
	return timer_apertura.time_left


# (Opcional) Cada frame, actualizar la UI con el tiempo restante
func _process(_delta: float) -> void:
	if not esta_abierta and timer_apertura.is_stopped() == false:
		actualizar_interfaz_tiempo()


func actualizar_interfaz_tiempo() -> void:
	var interfaz = get_tree().get_first_node_in_group("interfaz")
	if interfaz:
		interfaz.actualizar_tiempo_barrera(obtener_tiempo_restante())

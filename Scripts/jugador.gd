extends CharacterBody2D

# --- SISTEMA DE EPP ---
# Definimos los tipos de Equipo de Protección Personal
enum EPP { CASCO, OREJERAS, BOTAS_DIELECTRICAS }
# Diccionario para saber qué tiene equipado actualmente el técnico
var epp_equipado = {
	EPP.CASCO: false,
	EPP.OREJERAS: false,
	EPP.BOTAS_DIELECTRICAS: false
}

# --- VARIABLES DE SALUD ---
var salud_max: float = 100.0
var salud_actual: float = 100.0
var esta_vivido: bool = true

# --- VARIABLES DE MOVIMIENTO ---
@export var velocidad: float = 150.0 # velocidad de los sprites

# --- REFERENCIAS VISUALES ---
@onready var anim_player = $AnimationPlayer
@onready var sprite_idle = $Idle
@onready var sprite_walk = $Walk

var last_direction = Vector2.DOWN

# --- SISTEMA DE INVENTARIO ---
enum Herramientas { NINGUNA, LLAVE_INGLESA, EXTINTOR, MULTIMETRO }
var herramienta_activa: Herramientas = Herramientas.NINGUNA

func _ready() -> void:
	print("--- DEMO DE MANTENIMIENTO CRÍTICO INICIADA ---")
	print("Presiona 1, 2 o 3 para equipar una herramienta.")
	# Esperamos un frame para asegurarnos de que la interfaz ya cargó en el mapa
	await get_tree().process_frame
	actualizar_ui_salud()
	actualizar_ui_epp()

func _physics_process(delta: float) -> void:
	# Sistema de vectores para controla inputs
	var direccion = Input.get_vector("mover_izquierda", "mover_derecha", "mover_arriba", "mover_abajo")
	
	if direccion != Vector2.ZERO:
		velocity = direccion * velocidad
		last_direction = direccion
		
		# Control de visibilidad de spritesheets
		sprite_walk.visible = true
		sprite_idle.visible = false
	else:
		velocity = Vector2.ZERO
		
		sprite_idle.visible = true
		sprite_walk.visible = false
		
	move_and_slide()
	update_animation(direccion)

func _input(event: InputEvent) -> void:
	# Sistema de inventario por consola
	if Input.is_action_just_pressed("herramienta_1"):
		herramienta_activa = Herramientas.LLAVE_INGLESA
		actualizar_ui_herramienta()
		print("Herramienta equipada: LLAVE INGLESA")
	elif Input.is_action_just_pressed("herramienta_2"):
		herramienta_activa = Herramientas.EXTINTOR
		actualizar_ui_herramienta()
		print("Herramienta equipada: EXTINTOR")
	elif Input.is_action_just_pressed("herramienta_3"):
		herramienta_activa = Herramientas.MULTIMETRO
		actualizar_ui_herramienta()
		print("Herramienta equipada: MULTÍMETRO")
	
	# TEST TEMPORAL DE DAÑO
	#if Input.is_action_just_pressed("ui_accept"): # Al presionar Enter / Espacio
		#recibir_danio(15.0)
		
	# TEST TEMPORAL DE EPP: Al presionar la tecla "Tab" equipa el casco automáticamente
	if Input.is_action_just_pressed("ui_focus_next"): # Por defecto suele ser la tecla Tab
		equipar_epp(EPP.CASCO)

# FUNCIÓN DE ANIMACIÓN
func update_animation(direction: Vector2):
	if direction != Vector2.ZERO:
		if direction.x > 0:
			anim_player.play("walk_right")
		elif direction.x < 0:
			anim_player.play("walk_left")
		elif direction.y > 0:
			anim_player.play("walk_down")
		elif direction.y < 0:
			anim_player.play("walk_up")
	else:
		if last_direction.x > 0:
			anim_player.play("idle_right")
		elif last_direction.x < 0:
			anim_player.play("idle_left")
		elif last_direction.y > 0:
			anim_player.play("idle_down")
		elif last_direction.y < 0:
			anim_player.play("idle_up")

func actualizar_ui_herramienta() -> void:
	var interfaz = get_parent().get_node_or_null("Interfaz")
	if interfaz:
		match herramienta_activa:
			Herramientas.NINGUNA: interfaz.cambiar_icono_herramienta("NINGUNA")
			Herramientas.LLAVE_INGLESA: interfaz.cambiar_icono_herramienta("LLAVE")
			Herramientas.EXTINTOR: interfaz.cambiar_icono_herramienta("EXTINTOR")
			Herramientas.MULTIMETRO: interfaz.cambiar_icono_herramienta("MULTIMETRO")

# --- Funciones de danio ---
func recibir_danio(cantidad: float) -> void:
	if not esta_vivido:
		return
		
	# Restamos vida y nos aseguramos de que no baje de 0 ni suba de 100
	salud_actual = clampf(salud_actual - cantidad, 0.0, salud_max)
	
	# Avisamos a la Interfaz para que se actualice visualmente
	actualizar_ui_salud()
	
	# Verificamos la condición de derrota por accidente laboral
	if salud_actual <= 0.0:
		morir_por_accidente()

func actualizar_ui_salud() -> void:
	# Buscamos el nodo Interfaz en la raíz de la escena para mandarle los datos
	var interfaz = owner.get_node_or_null("Interfaz")
	if interfaz:
		interfaz.actualizar_vida(salud_actual)

func morir_por_accidente() -> void:
	esta_vivido = false
	set_physics_process(false) # Bloqueamos el movimiento del jugador
	print("🚨 Accidente Laboral Crítico: El técnico quedó incapacitado.")
	
	# Comunicamos al cerebro global (Mundo) que detenga el juego
	if owner and owner.has_method("derrota_juego"):
		owner.derrota_juego()



# Función para equipar un EPP
func equipar_epp(tipo_epp: int) -> void:
	if epp_equipado.has(tipo_epp):
		epp_equipado[tipo_epp] = true
		print("🛡️ EPP Equipado exitosamente: ", EPP.keys()[tipo_epp])
		actualizar_ui_epp()

func actualizar_ui_epp() -> void:
	var interfaz = owner.get_node_or_null("Interfaz")
	if interfaz:
		# Le pasamos el diccionario completo a la interfaz para que se actualice
		interfaz.actualizar_ranuras_epp(epp_equipado)

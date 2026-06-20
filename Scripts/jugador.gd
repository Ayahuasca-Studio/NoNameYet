extends CharacterBody2D

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
		print("Herramienta equipada: LLAVE INGLESA")
	elif Input.is_action_just_pressed("herramienta_2"):
		herramienta_activa = Herramientas.EXTINTOR
		print("Herramienta equipada: EXTINTOR")
	elif Input.is_action_just_pressed("herramienta_3"):
		herramienta_activa = Herramientas.MULTIMETRO
		print("Herramienta equipada: MULTÍMETRO")

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

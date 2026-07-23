extends StaticBody2D

# VARIABLES EXPORTADAS (Ajustables en el Inspector)
@export var puntos_necesarios: int = 100
@export var mensaje_abierto: String = "¡Puntaje alcanzado! Escaleras desbloqueadas."

# REFERENCIAS A NODOS
@onready var sprite: Sprite2D = $Sprite2D
@onready var colision: CollisionShape2D = $CollisionShape2D

# ESTADOS
var esta_abierta: bool = false
var score_manager: Node = null # Guardaremos la referencia a tu nodo Score aquí

func _ready() -> void:
	# 1. Asegurar estado inicial (cerrado y bloqueando)
	esta_abierta = false
	colision.disabled = false
	if sprite:
		sprite.visible = true

func _process(_delta: float) -> void:
	# Si ya se abrió, no necesitamos seguir verificando nada
	if esta_abierta:
		return
		
	# 1. Buscamos el nodo Score (que está en el grupo "score_manager") si aún no lo tenemos
	if not score_manager:
		score_manager = get_tree().get_first_node_in_group("score_manager")
		return
		
	# 2. Verificamos constantemente si el jugador ya alcanzó o superó los puntos
	if score_manager.puntaje_total >= puntos_necesarios:
		abrir_barrera()

func abrir_barrera() -> void:
	if esta_abierta: 
		return # Evitar doble ejecución

	esta_abierta = true

	print("🚨 Barrera: ¡Puntos alcanzados! Abriendo acceso a escaleras.")


	# 1. Efecto Visual
	# Opción A: Ocultar el sprite
	if sprite:
		sprite.visible = false

	colision.disabled = true 
	
	# Si todo el nodo debe desaparecer por completo:
	# visible = false

	# 3. Avisar a la Interfaz y reproducir sonido de logro
	if AudioConfig:
		AudioConfig.play_sfx(AudioConfig.SFX_REPAIR_SUCCESS)
		
	var interfaz = get_tree().get_first_node_in_group("interfaz")
	if interfaz and interfaz.has_method("mostrar_notificacion"):
		interfaz.mostrar_notificacion(mensaje_abierto)
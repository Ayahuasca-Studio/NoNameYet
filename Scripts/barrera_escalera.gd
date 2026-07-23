extends StaticBody2D

# VARIABLES EXPORTADAS (Ajustables en el Inspector)
@export var puntos_necesarios: int = 100
@export var mensaje_abierto: String = "¡Puntaje alcanzado! Escaleras desbloqueadas."

# OPCIONAL: Arrastra aquí tu Label 'Noticia' desde el Inspector
@export var label_noticia: Label

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
		
	# 2. Nos aseguramos de que el Label empiece oculto al cargar la escena
	if label_noticia:
		label_noticia.visible = false

func _process(_delta: float) -> void:
	# Si ya se abrió, no necesitamos seguir verificando
	if esta_abierta:
		return
		
	# Buscamos el nodo Score si aún no lo tenemos
	if not score_manager:
		score_manager = get_tree().get_first_node_in_group("score_manager")
		return
		
	# Verificamos si el jugador alcanzó el puntaje necesario
	if score_manager.puntaje_total >= puntos_necesarios:
		abrir_barrera()

func abrir_barrera() -> void:
	if esta_abierta: 
		return # Evitar doble ejecución

	esta_abierta = true
	print("🚨 Barrera: ¡Puntos alcanzados! Abriendo acceso.")

	# 1. Ocultar la barrera y quitar colisión
	if sprite:
		sprite.visible = false
	colision.disabled = true 

	# 2. Hacer visible tu Label tal y como lo configuraste
	if label_noticia:
		label_noticia.visible = true

	# 3. Sonido y notificación a la UI
	if AudioConfig:
		AudioConfig.play_sfx(AudioConfig.SFX_REPAIR_SUCCESS)
		
	var interfaz = get_tree().get_first_node_in_group("interfaz")
	if interfaz and interfaz.has_method("mostrar_notificacion"):
		interfaz.mostrar_notificacion(mensaje_abierto)

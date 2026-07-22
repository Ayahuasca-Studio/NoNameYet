extends Area2D

# Array para cargar las 4 imágenes desde el Inspector
@export var imagenes_casillero: Array[Texture2D] = []

# Tamaño objetivo en píxeles que quieres que tenga en pantalla (ej: 16 ancho x 32 alto)
@export var tamano_objetivo: Vector2 = Vector2(16, 32) 

# Identificador: 0 = Casco, 1 = Orejeras, 2 = Botas, etc.
@export var epp_a_entregar: int = 0:
	set(value):
		epp_a_entregar = value
		if is_node_ready(): # Evita errores si la escena aún no carga
			actualizar_sprite()

@export var nombre_item: String = "Casco de Seguridad"

var jugador_cerca: CharacterBody2D = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var indicador_interaccion: Label = $IndicadorCasillero 

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	actualizar_sprite()
	
	# Texto de "Presiona E", mantenerlo oculto al inicio
	if indicador_interaccion != null:
		indicador_interaccion.visible = false

# Función para cambiar y reescalar la imagen
func actualizar_sprite() -> void:
	if sprite == null or imagenes_casillero.is_empty():
		return
		
	if epp_a_entregar >= 0 and epp_a_entregar < imagenes_casillero.size():
		var nueva_textura = imagenes_casillero[epp_a_entregar]
		if nueva_textura != null:
			sprite.texture = nueva_textura
			
			# Calculamos la escala basada en el tamaño real de la imagen
			var tamano_imagen = nueva_textura.get_size()
			if tamano_imagen.x > 0 and tamano_imagen.y > 0:
				sprite.scale = tamano_objetivo / tamano_imagen

func _on_body_entered(body: Node) -> void:
	if body.has_method("equipar_epp"):
		jugador_cerca = body
		if indicador_interaccion:
			indicador_interaccion.visible = true
		print("Cerca de: ", nombre_item, ". Presiona 'E' para equipar.")

func _on_body_exited(body: Node) -> void:
	if body == jugador_cerca:
		jugador_cerca = null
		if indicador_interaccion:
			indicador_interaccion.visible = false

func _input(event: InputEvent) -> void:
	# Si el jugador está cerca y presiona la tecla de acción/interacción
	if jugador_cerca and Input.is_action_just_pressed("recoger_epp"):
		AudioConfig.play_sfx(AudioConfig.SFX_EQUIP)
		# Equipamos al jugador usando la función
		jugador_cerca.equipar_epp(epp_a_entregar)

		# Feedback visual opcional: podemos hacer que el casillero se quede vacío o cambie de color
		print("El técnico recogió: ", nombre_item)
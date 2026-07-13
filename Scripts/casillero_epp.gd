extends Area2D

# Exportamos variables para configurar qué da cada casillero desde el Inspector
@export var epp_a_entregar: int = 0 # 0 = Casco, 1 = Orejeras, 2 = Botas
@export var nombre_item: String = "Casco de Seguridad"

var jugador_cerca: CharacterBody2D = null
@onready var indicador_interaccion: Label = $IndicadorCasillero # Si pusiste un Label de "Presiona E", vincúlalo aquí

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Texto de "Presiona E", mantenerlo oculto al inicio
	if indicador_interaccion != null:
		indicador_interaccion.visible = false

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
		# Equipamos al jugador usando la función
		jugador_cerca.equipar_epp(epp_a_entregar)
		
		# Feedback visual opcional: podemos hacer que el casillero se quede vacío o cambie de color
		print("El técnico recogió: ", nombre_item)

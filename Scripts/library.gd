extends Area2D

# 1. RUTA EXPORTADA: Arrastra el nodo raíz de tu Manual (CanvasLayer) aquí desde el Inspector
@export var manual_canvas: CanvasLayer
@export var nombre_interaccion: String = "Manual de Instrucciones"

var jugador_cerca: Node2D = null

@onready var indicador_interaccion: Label = $IndicadorCasillero 

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Aseguramos que el texto de "Presiona E" empiece oculto
	if indicador_interaccion != null:
		indicador_interaccion.visible = false
		
	# Aseguramos que el manual empiece oculto al cargar la escena
	if manual_canvas != null:
		manual_canvas.visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Jugador": # O la validación que uses para tu jugador
		jugador_cerca = body
		if indicador_interaccion:
			indicador_interaccion.visible = true
		print("Cerca de: ", nombre_interaccion, ". Presiona la tecla para leer.")

func _on_body_exited(body: Node2D) -> void:
	if body == jugador_cerca:
		jugador_cerca = null
		if indicador_interaccion:
			indicador_interaccion.visible = false
		
		# DETALLE USABILIDAD: Si el jugador se aleja caminando, cerramos el manual automáticamente
		if manual_canvas != null and manual_canvas.visible:
			cerrar_manual()

# Usamos _unhandled_input para que no interfiera si ya estás haciendo clic dentro de la UI del manual
func _unhandled_input(event: InputEvent) -> void:
	# Si el jugador está cerca y presiona la tecla de acción (puedes cambiar "recoger_epp" por "ui_accept" si prefieres Enter/Espacio)
	if jugador_cerca and event.is_action_pressed("recoger_epp"):
		alternar_manual()

func alternar_manual() -> void:
	if manual_canvas == null:
		print("⚠️ Error: No has asignado el nodo del manual en el Inspector.")
		return

	# Si está oculto lo muestra, si está visible lo cierra (Toggle)
	if not manual_canvas.visible:
		abrir_manual()
	else:
		cerrar_manual()

func abrir_manual() -> void:
	manual_canvas.visible = true
	if AudioConfig:
		AudioConfig.play_sfx(AudioConfig.SFX_CLICK) # O un sonido de abrir papel/libro si tienes
	print("📖 Manual abierto.")
	
	# OPCIONAL: Si quieres que el texto de "Presiona E" se oculte mientras lee el manual:
	if indicador_interaccion:
		indicador_interaccion.visible = false

func cerrar_manual() -> void:
	manual_canvas.visible = false
	if AudioConfig:
		AudioConfig.play_sfx(AudioConfig.SFX_CLICK)
	print("📕 Manual cerrado.")
	
	# Vuelve a mostrar el indicador de "Presiona E" si el jugador sigue en el área
	if jugador_cerca and indicador_interaccion:
		indicador_interaccion.visible = true
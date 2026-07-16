extends Area2D

# Exportamos variables para configurarlas de forma independiente en cada zona desde el editor
@export var epp_requerido: int = 0 # 0 = Casco, 1 = Orejeras, 2 = Botas
@export var danio_por_segundo: float = 10.0
@export var mensaje_alerta: String = "¡Zona peligrosa! Se requiere protección."

@onready var timer_danio: Timer = $TimerDanio
var jugador_en_zona: CharacterBody2D = null

func _ready() -> void:
	# Conectamos las señales nativas del Area2D por código para evitar errores
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Configuramos el temporizador para que se ejecute en bucle cada 1 segundo
	timer_danio.wait_time = 1.0
	timer_danio.one_shot = false
	timer_danio.timeout.connect(_on_timer_danio_timeout)

func _on_body_entered(body: Node) -> void:
	# Verificamos si lo que entró a la zona es el técnico
	if body.has_method("recibir_danio"):
		jugador_en_zona = body
		evaluar_peligro()

func _on_body_exited(body: Node) -> void:
	if body == jugador_en_zona:
		jugador_en_zona = null
		timer_danio.stop() # Detenemos el dreno de vida inmediatamente al salir
		print("🚶 El técnico salió de la zona de riesgo.")

func evaluar_peligro() -> void:
	if not jugador_en_zona:
		return
		
	# Revisamos el diccionario de EPP que programamos en la Fase 2
	var tiene_proteccion = jugador_en_zona.epp_equipado[epp_requerido]
	
	if tiene_proteccion:
		print("🛡️ Técnico seguro. Lleva el EPP adecuado para esta zona.")
		timer_danio.stop()
	else:
		print("⚠️ ", mensaje_alerta)
		# Aplicamos el primer golpe de daño inmediato y encendemos el reloj
		jugador_en_zona.recibir_danio(danio_por_segundo)
		timer_danio.start()

# Cada segundo que pasa, si el jugador sigue aquí sin protección, sufre daño
func _on_timer_danio_timeout() -> void:
	if jugador_en_zona:
		# Volvemos a evaluar por si se equipó el EPP dentro de la zona
		var tiene_proteccion = jugador_en_zona.epp_equipado[epp_requerido]
		if tiene_proteccion:
			timer_danio.stop()
		else:
			jugador_en_zona.recibir_danio(danio_por_segundo)

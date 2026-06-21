extends Area2D

# Enums idénticos para coordinar estados y herramientas
enum Estados { NORMAL, ROTA, INCENDIO, SOBRECARGA }
var estado_actual: Estados = Estados.NORMAL

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

# VARIABLE: Guarda si el jugador está dentro del rango de la máquina
var jugador_en_rango: Node2D = null

# --- Funcion: Se llama solo una vez al iniciar la escena ---
func _ready() -> void:
	# Configuracion  del timer
	timer.wait_time = randf_range(3.0, 7.0)
	timer.autostart = true
	# Conectar la señal para el cambio de estado
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
	# --- CONECTAR SEÑALES DE DETECCION ---
	# body_entered se activa cuando un CharacterBody2D (el jugador) entra al área azul
	body_entered.connect(_on_body_entered)
	# body_exited se activa cuando el jugador se aleja y sale del área azul
	body_exited.connect(_on_body_exited)
	
	actualizar_visualizacion()

#--- Funcion: Cambia el estado de la maquina
func _on_timer_timeout() -> void:
	if estado_actual != Estados.NORMAL:
		return
	var nueva_falla = randi_range(1, 3)
	estado_actual = nueva_falla as Estados
	actualizar_visualizacion()
	
	timer.wait_time = randf_range(5.0, 10.0)
	timer.start()

# --- Funcion: entrada del jugador en el area de la maquina ---
func _on_body_entered(body: Node2D) -> void:
	# Verificamos si lo que entró es nuestro jugador (buscando su script o nombre)
	if body.name == "Jugador":
		jugador_en_rango = body
		print("El técnico se acercó a la máquina.")

# --- Funcion: salida del jugador en el area de la maquina ---
func _on_body_exited(body: Node2D) -> void:
	if body.name == "Jugador":
		jugador_en_rango = null
		print("El técnico se alejó de la máquina.")

# --- Funcion: Captura la interaccion del jugador ---
func _input(event: InputEvent) -> void:
	# Si el jugador está cerca Y presiona la BARRA ESPACIADORA (ui_accept es espacio/enter por defecto)
	if jugador_en_rango != null and Input.is_action_just_pressed("ui_accept"):
		intentar_reparar()

# ---Funcion: validar la herramienta correcta ---
func intentar_reparar() -> void:
	# Obtenemos qué herramienta tiene el jugador en la mano leyendo su variable
	var herramienta_jugador = jugador_en_rango.herramienta_activa
	
	# Usamos un booleano para saber si la reparación tuvo éxito
	var exito: bool = false
	
	# Evaluamos las condiciones de Mantenimiento:
	if estado_actual == Estados.ROTA and herramienta_jugador == 1: # 1 = LLAVE_INGLESA
		exito = true
	elif estado_actual == Estados.INCENDIO and herramienta_jugador == 2: # 2 = EXTINTOR
		exito = true
	elif estado_actual == Estados.SOBRECARGA and herramienta_jugador == 3: # 3 = MULTIMETRO
		exito = true
		
	if exito:
		print("¡Reparación exitosa! Máquina restaurada.")
		estado_actual = Estados.NORMAL
		actualizar_visualizacion()
		
		# Restamos 25 puntos de estrés acumulado al reparar con éxito
		var mundo = owner
		if mundo and mundo.has_method("modificar_estres"):
			mundo.modificar_estres(-25.0)
	else:
		if estado_actual == Estados.NORMAL:
			print("La máquina no necesita mantenimiento en este momento.")
		else:
			print("¡Herramienta incorrecta! No puedes solucionar esta falla con lo que tienes equipado.")

func actualizar_visualizacion() -> void:
	match estado_actual:
		Estados.NORMAL:
			sprite.modulate = Color.WHITE
			print("Máquina operando con normalidad.")
		Estados.ROTA:
			sprite.modulate = Color.BROWN
			print("¡ALERTA! Se requiere Llave Inglesa (Tecla 1).")
		Estados.INCENDIO:
			sprite.modulate = Color.RED
			print("¡ALERTA! Se requiere Extintor (Tecla 2).")
		Estados.SOBRECARGA:
			sprite.modulate = Color.YELLOW
			print("¡ALERTA! Se requiere Multímetro (Tecla 3).")

# _process corre en cada frame de renderizado. 
# Lo usamos para que si la máquina está dañada, sume estrés constantemente.
func _process(delta: float) -> void:
	if estado_actual != Estados.NORMAL:
		# Si la máquina tiene una falla, le pide al escenario principal (Mundo) 
		# que sume estrés a la planta. Multiplicamos por delta para que sea constante.
		var mundo = owner
		if mundo and mundo.has_method("modificar_estres"):
			mundo.modificar_estres(2.0 * delta) # Sube 2 puntos de estrés por segundo

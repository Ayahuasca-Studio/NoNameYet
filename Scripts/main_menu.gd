extends Control 

# --- RUTA DE BOTONES PRINCIPALES
@onready var btn_jugar = $CanvasLayer/Play
@onready var btn_opciones = $CanvasLayer/Options
@onready var btn_salir_principal = $CanvasLayer/Exit

# --- CONTENEDOR DE NIVELES 
@onready var menu_niveles = $Level
@onready var btn_nivel_1 = $Level/One
@onready var btn_nivel_2 = $Level/Two
@onready var btn_nivel_3 = $Level/Three
@onready var btn_salir_niveles = $Level/Exit

func _ready():
	# niveles ocultos al inicio
	menu_niveles.visible = false
	
	# 2. Conectar señales del menú principal
	btn_jugar.pressed.connect(_on_btn_jugar_pressed)
	btn_opciones.pressed.connect(_on_btn_opciones_pressed)
	btn_salir_principal.pressed.connect(_on_btn_salir_principal_pressed)
	
	# 3. Conectar señales del menú de niveles
	btn_nivel_1.pressed.connect(_on_nivel_seleccionado)
	btn_nivel_2.pressed.connect(_on_nivel_seleccionado)
	btn_nivel_3.pressed.connect(_on_nivel_seleccionado)
	btn_salir_niveles.pressed.connect(_on_btn_salir_niveles_pressed)



func _on_btn_jugar_pressed():
	# En lugar de cambiar de escena directo, mostramos el menú de niveles
	menu_niveles.visible = true

func _on_btn_opciones_pressed():
	print("Abrir panel de opciones (pendiente de implementar)")

func _on_btn_salir_principal_pressed():
	get_tree().quit()


# --- LÓGICA DEL MENÚ DE NIVELES ---

func _on_nivel_seleccionado():
	# Redirige a la planta baja (por ahora todos) 
	get_tree().change_scene_to_file("res://planta_baja.tscn")

func _on_btn_salir_niveles_pressed():
	# Oculta el menú de niveles y vuelve a dejar interactuable el menú principal
	menu_niveles.visible = false

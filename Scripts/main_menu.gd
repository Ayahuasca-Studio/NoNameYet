extends Control 

# --- RUTAS EXPORTADAS (Las asignas desde el Inspector en Godot) ---
@export_file("*.tscn") var escena_opciones: String
@export_file("*.tscn") var escena_nivel_1: String
@export_file("*.tscn") var escena_nivel_2: String
@export_file("*.tscn") var escena_nivel_3: String

# --- RUTA DE BOTONES PRINCIPALES ---
@onready var btn_jugar = $CanvasLayer/Play
@onready var btn_opciones = $CanvasLayer/Options
@onready var btn_salir_principal = $CanvasLayer/Exit

# --- CONTENEDOR DE NIVELES ---
@onready var menu_niveles = $Level
@onready var btn_nivel_1 = $Level/One
@onready var btn_nivel_2 = $Level/Two
@onready var btn_nivel_3 = $Level/Three
@onready var btn_salir_niveles = $Level/Exit

func _ready() -> void:
	# Niveles ocultos al inicio
	menu_niveles.visible = false

	# Música de fondo del menú
	AudioConfig.play_music(AudioConfig.MUSIC_MENU)

	# 2. Conectar señales del menú principal
	btn_jugar.pressed.connect(_on_btn_jugar_pressed)
	btn_opciones.pressed.connect(_on_btn_opciones_pressed)
	btn_salir_principal.pressed.connect(_on_btn_salir_principal_pressed)
	
	# 3. Conectar señales del menú de niveles
	btn_nivel_1.pressed.connect(_on_nivel_1_pressed)
	btn_nivel_2.pressed.connect(_on_nivel_2_pressed)
	btn_nivel_3.pressed.connect(_on_nivel_3_pressed)
	btn_salir_niveles.pressed.connect(_on_btn_salir_niveles_pressed)


func _on_btn_jugar_pressed() -> void:
	AudioConfig.play_sfx(AudioConfig.SFX_CLICK)
	menu_niveles.visible = true

func _on_btn_opciones_pressed() -> void:
	AudioConfig.play_sfx(AudioConfig.SFX_CLICK)
	_cargar_escena(escena_opciones)

func _on_btn_salir_principal_pressed() -> void:
	AudioConfig.play_sfx(AudioConfig.SFX_CLICK)
	get_tree().quit()


# --- LÓGICA DEL MENÚ DE NIVELES ---

func _on_nivel_1_pressed() -> void:
	AudioConfig.play_sfx(AudioConfig.SFX_CLICK)
	_cargar_escena(escena_nivel_1)

func _on_nivel_2_pressed() -> void:
	AudioConfig.play_sfx(AudioConfig.SFX_CLICK)
	_cargar_escena(escena_nivel_2)

func _on_nivel_3_pressed() -> void:
	AudioConfig.play_sfx(AudioConfig.SFX_CLICK)
	_cargar_escena(escena_nivel_3)

func _on_btn_salir_niveles_pressed() -> void:
	AudioConfig.play_sfx(AudioConfig.SFX_CLICK)
	menu_niveles.visible = false

# Función auxiliar segura para cargar escenas
func _cargar_escena(ruta_escena: String) -> void:
	if ruta_escena != "":
		get_tree().change_scene_to_file(ruta_escena)
	else:
		print("⚠️ No has asignado la escena correspondiente en el Inspector del Menú.")
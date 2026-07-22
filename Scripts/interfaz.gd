extends CanvasLayer

#--- EPP ---
# Referencias a los iconos de la HUD
@onready var icono_casco: TextureRect = $HUD/ContenedorEPP/IconoCasco
@onready var icono_orejeras: TextureRect = $HUD/ContenedorEPP/IconoOrejeras
@onready var icono_botas: TextureRect = $HUD/ContenedorEPP/IconoBotas

# --- Vida ---
@onready var barra_vida: ProgressBar = $HUD/BarraVida

@onready var barra_estres = $HUD/BarraEstres
@onready var icono_herramienta = $HUD/IconoHerramienta

@onready var label_tiempo_barrera: Label = $HUD/LabelTiempoBarrera

# Definimos las coordenadas (Rect2) de cada herramienta en el atlas
var regiones = {
	"NINGUNA": Rect2(0, 0, 0, 0), # Vacío
	"LLAVE": Rect2(208, 1632, 16, 16),   # X, Y, Ancho, Alto
	"EXTINTOR": Rect2(32, 40, 16, 16),
	"MULTIMETRO": Rect2(0, 40, 16, 16)
}

func _ready() -> void:
	cambiar_icono_herramienta("NINGUNA")
	if label_tiempo_barrera:
		label_tiempo_barrera.visible = false
	# Importante: Añadir la interfaz al grupo para que la barrera la encuentre
	add_to_group("interfaz")
	
	
func actualizar_estres(valor: float) -> void:
	barra_estres.value = valor

func cambiar_icono_herramienta(tipo: String) -> void:
	# Accedemos al Atlas que creamos en el paso anterior
	var atlas = icono_herramienta.texture as AtlasTexture
	if atlas and regiones.has(tipo):
		# Cambiamos qué parte de la imagen se muestra
		atlas.region = regiones[tipo]
		
		# Si es 'NINGUNA', ocultamos el icono, si no, lo mostramos
		icono_herramienta.visible = (tipo != "NINGUNA")


# --- Funciones Vida ---
func actualizar_vida(valor: float) -> void:
	if barra_vida:
		barra_vida.value = valor


# --- Funciones de EPP ---
func actualizar_ranuras_epp(epp_estado: Dictionary) -> void:
	# Si está equipado (true), modulación normal (blanco/encendido)
	# Si no está equipado (false), modulación semitransparente/oscura
	if icono_casco:
		icono_casco.modulate = Color(1, 1, 1, 1) if epp_estado[0] else Color(0.3, 0.3, 0.3, 0.5)
		
	if icono_orejeras:
		icono_orejeras.modulate = Color(1, 1, 1, 1) if epp_estado[1] else Color(0.3, 0.3, 0.3, 0.5)
		
	if icono_botas:
		icono_botas.modulate = Color(1, 1, 1, 1) if epp_estado[2] else Color(0.3, 0.3, 0.3, 0.5)
		

# Nueva función para que la barrera mande el tiempo
func actualizar_tiempo_barrera(segundos: float) -> void:
	if label_tiempo_barrera:
		if segundos > 0:
			label_tiempo_barrera.visible = true
			# Usamos string formatting para redondear el float a entero
			label_tiempo_barrera.text = "⏱️ PB Restringida: %d s" % int(segundos)
		else:
			label_tiempo_barrera.visible = false

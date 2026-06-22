extends CanvasLayer

@onready var barra_estres = $HUD/BarraEstres
@onready var icono_herramienta = $HUD/IconoHerramienta

# Definimos las coordenadas (Rect2) de cada herramienta en el atlas
var regiones = {
	"NINGUNA": Rect2(0, 0, 0, 0), # Vacío
	"LLAVE": Rect2(208, 1632, 16, 16),   # X, Y, Ancho, Alto
	"EXTINTOR": Rect2(32, 40, 16, 16),
	"MULTIMETRO": Rect2(0, 40, 16, 16)
}

func _ready() -> void:
	cambiar_icono_herramienta("NINGUNA")
	
	
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

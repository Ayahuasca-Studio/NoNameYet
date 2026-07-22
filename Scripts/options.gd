extends Control

@onready var sound_button: TextureButton = $SoundButton

func _ready() -> void:

	sound_button.button_pressed = not AudioConfig.sound_enabled
	sound_button.toggled.connect(_on_sound_button_toggled)

func _on_sound_button_toggled(is_pressed: bool) -> void:
	# Si el botón está presionado (abajo), significa que apunta a "NO" -> sonido desactivado (false)
	# Si no está presionado (arriba), significa que apunta a "SÍ" -> sonido activado (true)

	

	var sound_state = not is_pressed

	# Reproducimos el click ANTES de aplicar el posible mute, para que siempre se escuche
	AudioConfig.play_sfx(AudioConfig.SFX_CLICK)

	 Sounds-&-Effects
	# Actualiza el estado global y silencia el juego
	AudioConfig.set_sound(sound_state)
	print("Sonido configurado en: ", sound_state)
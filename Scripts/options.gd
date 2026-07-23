extends Control

@onready var sound_button: TextureButton = $SoundButton
@onready var slider_general: HSlider = $VolumePanelBg/VolumeContainer/GeneralRow/SliderGeneral
@onready var slider_musica: HSlider = $VolumePanelBg/VolumeContainer/MusicaRow/SliderMusica
@onready var slider_efectos: HSlider = $VolumePanelBg/VolumeContainer/EfectosRow/SliderEfectos
@onready var volver_button: TextureButton = $VolverButton
@onready var exit_button: Button = $Exit

func _ready() -> void:
	sound_button.button_pressed = not AudioConfig.sound_enabled
	sound_button.toggled.connect(_on_sound_button_toggled)

	# Inicializamos los sliders con el volumen actual guardado en AudioConfig
	slider_general.value = AudioConfig.master_volume
	slider_musica.value = AudioConfig.music_volume
	slider_efectos.value = AudioConfig.sfx_volume

	slider_general.value_changed.connect(_on_slider_general_changed)
	slider_musica.value_changed.connect(_on_slider_musica_changed)
	slider_efectos.value_changed.connect(_on_slider_efectos_changed)

	volver_button.pressed.connect(_on_volver_pressed)
	exit_button.pressed.connect(_on_volver_pressed)

func _on_sound_button_toggled(is_pressed: bool) -> void:
	# Si el botón está presionado (abajo), significa que apunta a "NO" -> sonido desactivado (false)
	# Si no está presionado (arriba), significa que apunta a "SÍ" -> sonido activado (true)
	var sound_state = not is_pressed

	# Reproducimos el click ANTES de aplicar el posible mute, para que siempre se escuche
	AudioConfig.play_sfx(AudioConfig.SFX_CLICK)

	# Actualiza el estado global y silencia el juego
	AudioConfig.set_sound(sound_state)
	print("Sonido configurado en: ", sound_state)

func _on_slider_general_changed(valor: float) -> void:
	AudioConfig.set_master_volume(valor)

func _on_slider_musica_changed(valor: float) -> void:
	AudioConfig.set_music_volume(valor)

func _on_slider_efectos_changed(valor: float) -> void:
	AudioConfig.set_sfx_volume(valor)

func _on_volver_pressed() -> void:
	AudioConfig.play_sfx(AudioConfig.SFX_CLICK)
	get_tree().change_scene_to_file("res://Niveles/main_menu.tscn")

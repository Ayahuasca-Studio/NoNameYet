extends Node

# Variable global que guarda si el sonido está activado o no
var sound_enabled: bool = true

# --- RUTAS DE AUDIO ---
# Coloca los archivos con estos nombres exactos dentro de Assets/Sounds
# (o cambia las rutas de abajo si prefieres otros nombres de archivo)
const SFX_CLICK: String = "res://Assets/Sounds/click.wav"
const SFX_GAME_OVER: String = "res://Assets/Sounds/game_over.wav"

# --- SFX de interacción con objetos ---
const SFX_REPAIR_SUCCESS: String = "res://Assets/Sounds/repair_success.wav"
const SFX_REPAIR_FAIL: String = "res://Assets/Sounds/repair_fail.wav"
const SFX_EQUIP: String = "res://Assets/Sounds/equip.wav"
const SFX_SWITCH: String = "res://Assets/Sounds/switch.wav"
const SFX_ALARM: String = "res://Assets/Sounds/alarm.ogg"
const SFX_HURT: String = "res://Assets/Sounds/hurt.ogg"
const SFX_MACHINE_BREAK: String = "res://Assets/Sounds/machine_break.ogg"
const SFX_STAIRS: String = "res://Assets/Sounds/stairs.ogg"
const SFX_FOOTSTEP: String = "res://Assets/Sounds/footstep.ogg"
const SFX_BARRIER_OPEN: String = "res://Assets/Sounds/barrier_open.ogg"
const SFX_PAGE_TURN: String = "res://Assets/Sounds/page_turn.wav"

const MUSIC_MENU: String = "res://Assets/Sounds/menu_music.ogg"
const MUSIC_LEVEL: String = "res://Assets/Sounds/level_music.ogg"

# --- VOLÚMENES (0.0 a 1.0), separados por bus ---
var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0

# --- REPRODUCTORES INTERNOS ---
# Usamos un pequeño pool de AudioStreamPlayer para que dos SFX simultáneos
# (ej: falla de reparación + daño al jugador en el mismo frame) no se corten entre sí.
const SFX_POOL_SIZE: int = 6
var _sfx_players: Array[AudioStreamPlayer] = []
var _music_player: AudioStreamPlayer
var _current_music_path: String = ""

func _ready() -> void:
	# Importante: el sonido no debe congelarse cuando el juego se pausa
	# (por ejemplo, al abrir el manual/guía, que pausa el árbol de la escena).
	# Sin esto, un SFX que empieza justo antes/durante la pausa se queda
	# "atascado" y puede sonar en loop infinito.
	process_mode = Node.PROCESS_MODE_ALWAYS

	_asegurar_bus("Music")
	_asegurar_bus("SFX")

	for i in SFX_POOL_SIZE:
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		p.process_mode = Node.PROCESS_MODE_ALWAYS
		add_child(p)
		_sfx_players.append(p)

	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	_music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_music_player)

## Crea el bus de audio si todavía no existe, como hijo de "Master".
func _asegurar_bus(nombre: String) -> void:
	if AudioServer.get_bus_index(nombre) == -1:
		var idx = AudioServer.bus_count
		AudioServer.add_bus(idx)
		AudioServer.set_bus_name(idx, nombre)
		AudioServer.set_bus_send(idx, "Master")

func _get_free_sfx_player() -> AudioStreamPlayer:
	for p in _sfx_players:
		if not p.playing:
			return p
	# Si todos están ocupados, reutilizamos el primero
	return _sfx_players[0]

func set_sound(enabled: bool) -> void:
	sound_enabled = enabled

	# Mutea o desmutea el bus principal de audio ("Master") en Godot
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus_index, not sound_enabled)

## volumen entre 0.0 (silencio) y 1.0 (máximo)
func set_master_volume(volumen: float) -> void:
	master_volume = clampf(volumen, 0.0, 1.0)
	var idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(idx, linear_to_db(master_volume))

func set_music_volume(volumen: float) -> void:
	music_volume = clampf(volumen, 0.0, 1.0)
	var idx = AudioServer.get_bus_index("Music")
	if idx != -1:
		AudioServer.set_bus_volume_db(idx, linear_to_db(music_volume))

func set_sfx_volume(volumen: float) -> void:
	sfx_volume = clampf(volumen, 0.0, 1.0)
	var idx = AudioServer.get_bus_index("SFX")
	if idx != -1:
		AudioServer.set_bus_volume_db(idx, linear_to_db(sfx_volume))

## Reproduce un efecto de sonido de una sola vez (clicks, botones, etc.)
## No hace nada (sin crashear) si el archivo todavía no existe.
func play_sfx(path: String) -> void:
	if not ResourceLoader.exists(path):
		push_warning("AudioConfig: no se encontró el sonido en " + path)
		return
	var player = _get_free_sfx_player()
	player.stream = load(path)
	player.play()

## Reproduce música de fondo en loop. Si ya está sonando esa misma pista, no la reinicia.
func play_music(path: String) -> void:
	if not ResourceLoader.exists(path):
		push_warning("AudioConfig: no se encontró la música en " + path)
		return
	if _current_music_path == path and _music_player.playing:
		return

	var stream = load(path)
	if "loop" in stream:
		stream.loop = true

	_current_music_path = path
	_music_player.stream = stream
	_music_player.play()

func stop_music() -> void:
	_music_player.stop()
	_current_music_path = ""

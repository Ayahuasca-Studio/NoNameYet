extends CharacterBody2D

# Esto creará una lista en el Inspector donde podrás meter tus 14 spritesheets
@export var skins_disponibles: Array[Texture2D]
# Con este número elegiremos cuál de los 14 usar (del 0 al 13)
@export var npc_id: int = 0
@onready var sprite = $Sprite2D
@export var animacion_inicial: String = "idle"
@onready var anim_player = $AnimationPlayer 


func _ready():
	# 1. Asignar la textura correcta
	if skins_disponibles.size() > 0 and npc_id < skins_disponibles.size():
		sprite.texture = skins_disponibles[npc_id]
		
	# 2. Reproducir la animación inicial
	# Verificamos que el AnimationPlayer exista y que la animación escrita esté creada
	if anim_player and anim_player.has_animation(animacion_inicial):
		anim_player.play(animacion_inicial)
	else:
		print("Advertencia: La animación '" + animacion_inicial + "' no existe en el NPC.")

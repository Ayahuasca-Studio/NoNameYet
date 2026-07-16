extends Control

@onready var anim_player = $AnimationPlayer
@onready var page_container = $PageContainer
@onready var interaction = $Interaction

var indice_actual = 0
var esta_animando = false

var paginas = []
var botones = []

func _ready():
	# 1. Guardar todas las páginas en orden y ocultarlas excepto la primera
	for i in page_container.get_child_count():
		var pagina = page_container.get_child(i)
		paginas.append(pagina)
		pagina.visible = (i == indice_actual) # Solo la página 0 empieza visible
		
	# 2. Guardar todos los botones en orden y conectarlos mediante código
	for i in interaction.get_child_count():
		var boton = interaction.get_child(i)
		botones.append(boton)
		# Conectamos el click del botón a nuestra función, pasándole su número de índice (0, 1, 2...)
		boton.pressed.connect(cambiar_pagina.bind(i))

# La función maestra que se ejecuta al presionar CUALQUIER botón de marcador
func cambiar_pagina(indice_destino):
	# Si ya está animando o si presionaste el botón de la página en la que ya estás, no hacemos nada
	if esta_animando or indice_destino == indice_actual:
		return
		
	esta_animando = true
	
	# PASO 1: Desvanecer el texto actual usando un Tween (Opacidad a 0)
	var tween_salida = create_tween()
	# Modificamos la 'a' (Alpha/Transparencia) del modulate del contenedor a 0.0 en 0.2 segundos
	tween_salida.tween_property(page_container, "modulate:a", 0.0, 0.2) 
	await tween_salida.finished
	
	# PASO 2: Cambiar el contenido invisiblemente
	for i in range(paginas.size()):
		paginas[i].visible = (i == indice_destino)
		
	# PASO 3: Decidir para dónde gira la página
	if indice_destino > indice_actual:
		# Si vamos a una página más adelante, giramos a la derecha
		anim_player.play("change_right")
	else:
		# Si vamos a una página anterior, giramos a la izquierda
		anim_player.play("change_left")
		
	await anim_player.animation_finished
	
	# Actualizamos nuestro registro de en qué página estamos ahora
	indice_actual = indice_destino
	
	var tween_entrada = create_tween()
	tween_entrada.tween_property(page_container, "modulate:a", 1.0, 0.2)
	await tween_entrada.finished
	
	esta_animando = false

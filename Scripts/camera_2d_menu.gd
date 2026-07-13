extends Camera2D

var tiempo: float = 0.0
var amplitud: float = 60.0 # Cuántos píxeles se moverá hacia los lados (ajústalo según el tamaño de tu fondo)
var velocidad: float = 0.5 # Qué tan rápido hará el recorrido

func _process(delta):
    tiempo += delta
    # Movimiento suave y automático en el eje X
    position.x = sin(tiempo * velocidad) * amplitud
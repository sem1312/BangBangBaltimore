extends Node2D

@export var vida: int = 30


var jugador: Node2D = null

func _ready():
	var jugadores = get_tree().get_nodes_in_group("player")
	if jugadores.size() > 0:
		jugador = jugadores[0]

func take_damage(cantidad: int = 1) -> void:
	vida -= cantidad
	print("¡Me dieron! Vida restante:", vida)

	if vida == 0:
		die()
		

func die() -> void:
	
	if jugador and jugador.has_method("enemy_muerto"):
		jugador.enemy_muerto()
		
	print("¡Muerto!")
	queue_free()

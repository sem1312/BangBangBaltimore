extends Node2D
var vida: int = 20
var jugador: Node2D = null

func _ready():
	$AnimatedSprite2D.sprite_frames = $AnimatedSprite2D.sprite_frames.duplicate()
	$AnimatedSprite2D.play("walk")
	var jugadores = get_tree().get_nodes_in_group("player")
	if jugadores.size() > 0:
		jugador = jugadores[0]


func take_damage(cantidad: int = 1) -> void:
	vida -= cantidad
	print("¡Me dieron! Vida restante:", vida)

	if vida <= 0:
		die()

func die() -> void:
	print("¡Muerto!")
	queue_free()

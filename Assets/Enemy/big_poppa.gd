extends Node2D

@export var vida: int = 30
@export var velocidad: float = 100.0  # velocidad en pixels/segundo

var enemigo_detectado: bool = false
var jugador: Node2D = null

@onready var caminar_area: Area2D = $Area2D

func _ready():
	var jugadores = get_tree().get_nodes_in_group("player")
	if jugadores.size() > 0:
		jugador = jugadores[0]

	caminar_area.body_entered.connect(_on_cuerpo_entrado)
	caminar_area.body_exited.connect(_on_cuerpo_salida)


func _physics_process(delta):
	if enemigo_detectado and jugador:
		var direccion = (jugador.global_position - global_position).normalized()
		global_position += direccion * velocidad * delta

func take_damage(cantidad: int = 1) -> void:
	vida -= cantidad
	print("¡Me dieron! Vida restante:", vida)

	if vida <= 0:
		die()
		
func _on_cuerpo_entrado(body: Node) -> void:
	if body.name == "Player":
		enemigo_detectado = true
		# si tienes temporizador para disparo, lo activas acá si quieres
		# temporizador_disparo.start()

func _on_cuerpo_salida(body: Node) -> void:
	if body.name == "Player":
		enemigo_detectado = false
		# temporizador_disparo.stop()

func die() -> void:
	if jugador and jugador.has_method("enemy_muerto"):
		jugador.enemy_muerto()
	print("¡Muerto!")
	queue_free()

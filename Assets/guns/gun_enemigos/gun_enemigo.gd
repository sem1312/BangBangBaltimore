extends Node2D

@onready var rotacion: Node2D = $rotacion
@onready var lugar_disparo_enemigo: Marker2D = $rotacion/Sprite2D/lugar_disparo_enemigo
@onready var tiempo_disparo: Timer = $tiempo_disparo

const escena_bala = preload("res://Assets/guns/bullet.tscn")
var fire_rate_enemigo: float = 0.25
var puede_disparar: bool = false

var jugador: Node2D = null
var area2d_player: Area2D = null

func _ready() -> void:
	var posible_ruta = "Main/Entities/Player/enemy_detection"
	if get_tree().get_root().has_node(posible_ruta):
		area2d_player = get_tree().get_root().get_node(posible_ruta)
		area2d_player.connect("body_entered", Callable(self, "_on_body_entered"))
		area2d_player.connect("body_exited", Callable(self, "_on_body_exited"))
	else:
		print("⚠ No se encontró el nodo:", posible_ruta)

	jugador = get_tree().get_root().get_node("Main/Entities/Player")
	tiempo_disparo.wait_time = fire_rate_enemigo
	tiempo_disparo.one_shot = true

	if not tiempo_disparo.is_connected("timeout", Callable(self, "_on_tiempo_disparo_timeout")):
		tiempo_disparo.connect("timeout", Callable(self, "_on_tiempo_disparo_timeout"))

func _physics_process(delta: float) -> void:
	if jugador:
		var objetivo_dir = -(jugador.global_position - global_position).angle() + PI
		rotacion.rotation = lerp_angle(rotacion.rotation, objetivo_dir, 6.5 * delta)

		if puede_disparar:
			_shoot()
			puede_disparar = false
			tiempo_disparo.start()

func _shoot():
	var nueva_bala = escena_bala.instantiate()
	nueva_bala.global_position = lugar_disparo_enemigo.global_position
	nueva_bala.rotation = lugar_disparo_enemigo.global_rotation
	get_tree().current_scene.add_child(nueva_bala)

func _on_tiempo_disparo_timeout() -> void:
	puede_disparar = false

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		puede_disparar = true

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		puede_disparar = false

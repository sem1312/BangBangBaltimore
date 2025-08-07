extends Node2D

@onready var rotacion: Node2D = $rotacion
@onready var lugar_disparo_enemigo: Marker2D = $rotacion/Sprite2D/lugar_disparo_enemigo
@onready var tiempo_disparo: Timer = $tiempo_disparo
@onready var area2d_player: Area2D = $detection_area

const escena_bala = preload("res://Assets/guns/bullet.tscn")
var fire_rate_enemigo: float = 0.25

var jugador_en_rango: bool = false
var jugador: Node2D = null

func _ready() -> void:
	area2d_player.connect("body_entered", Callable(self, "_on_body_entered"))
	area2d_player.connect("body_exited", Callable(self, "_on_body_exited"))

	jugador = get_tree().get_root().get_node("Main/Entities/Player")
	
	tiempo_disparo.wait_time = fire_rate_enemigo
	tiempo_disparo.one_shot = false
	if not tiempo_disparo.is_connected("timeout", Callable(self, "_on_tiempo_disparo_timeout")):
		tiempo_disparo.connect("timeout", Callable(self, "_on_tiempo_disparo_timeout"))

func _physics_process(delta: float) -> void:
	if jugador:
		var objetivo_dir = -(jugador.global_position - global_position).angle() + PI
		rotacion.rotation = lerp_angle(rotacion.rotation, objetivo_dir, 6.5 * delta)

func _on_tiempo_disparo_timeout() -> void:
	if jugador_en_rango:
		_shoot()

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		jugador_en_rango = true
		tiempo_disparo.start()

func _on_body_exited(body: Node) -> void:
	if body.name == "Player":
		jugador_en_rango = false
		tiempo_disparo.stop()

func _shoot():
	var nueva_bala = escena_bala.instantiate()
	nueva_bala.global_position = lugar_disparo_enemigo.global_position
	nueva_bala.rotation = lugar_disparo_enemigo.global_rotation
	get_tree().current_scene.add_child(nueva_bala)

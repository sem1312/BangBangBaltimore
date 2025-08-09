extends Node2D

@onready var rotacion: Node2D = $rotacion
@onready var lugar_disparo: Marker2D = $rotacion/Sprite2D/lugar_disparo
@onready var tiempo_disparo: Timer = $tiempo_disparo

const escena_bala = preload("res://Assets/guns/bullet.tscn")
var fire_rate: float = 0.25
var puede_disparar: bool = true

@onready var big_poppa: Node2D = get_parent().get_node("big_poppa")  # ajustá ruta si hace falta
var posicion_tp: Vector2 = Vector2(1722, 1427)

var min_angle = deg_to_rad(75)
var max_angle = deg_to_rad(130)

func _ready() -> void:
	tiempo_disparo.wait_time = fire_rate
	tiempo_disparo.one_shot = true
	
	if not tiempo_disparo.is_connected("timeout", Callable(self, "_on_tiempo_disparo_timeout")):
		tiempo_disparo.connect("timeout", Callable(self, "_on_tiempo_disparo_timeout"))

func _physics_process(delta: float) -> void:
	var objetivo_dir = (get_global_mouse_position() - global_position).angle()
	rotacion.rotation = lerp_angle(rotacion.rotation, objetivo_dir, 6.5 * delta)

	if Input.is_action_just_pressed("shoot") and puede_disparar:
		_shoot()
		puede_disparar = false
		tiempo_disparo.start()

func _shoot():
	var nueva_bala = escena_bala.instantiate()
	nueva_bala.global_position = lugar_disparo.global_position
	nueva_bala.rotation = lugar_disparo.global_rotation
	get_tree().current_scene.add_child(nueva_bala)
	
	var player_node = get_parent()
	
	if player_node.inside_exit_zone and player_node.enemies == 0:
		var current_rotation = fposmod(rotacion.rotation, PI * 2)
		if current_rotation >= min_angle and current_rotation <= max_angle:
			if big_poppa:
				big_poppa.global_position = posicion_tp
				print("hola")

func _on_tiempo_disparo_timeout() -> void:
	puede_disparar = true

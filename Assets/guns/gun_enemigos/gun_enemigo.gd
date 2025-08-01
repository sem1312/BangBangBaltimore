extends Node2D

@onready var rotacion: Node2D = $rotacion
@onready var lugar_disparo_enemigo: Marker2D = $rotacion/Sprite2D/lugar_disparo_enemigo
@onready var tiempo_disparo: Timer = $tiempo_disparo

const escena_bala = preload("res://Assets/guns/bullet.tscn")
var fire_rate_enemigo: float = 0.25
var puede_disparar: bool = true

var jugador: Node2D = null  # Referencia al jugador

func _ready() -> void:
	# Buscamos al jugador en el árbol de nodos solo una vez
	# Cambia "Main/Player" por el path correcto en tu escena
	jugador = get_tree().get_root().get_node("Main/Player")

	tiempo_disparo.wait_time = fire_rate_enemigo
	tiempo_disparo.one_shot = true
	
	if not tiempo_disparo.is_connected("timeout", Callable(self, "_on_tiempo_disparo_timeout")):
		tiempo_disparo.connect("timeout", Callable(self, "_on_tiempo_disparo_timeout"))

func _physics_process(delta: float) -> void:
	if jugador:
		# Apunta hacia el jugador
		var objetivo_dir = (jugador.global_position - global_position).angle()
		rotacion.rotation = lerp_angle(rotacion.rotation, objetivo_dir, 6.5 * delta)


		# Dispara si puede
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
	puede_disparar = true

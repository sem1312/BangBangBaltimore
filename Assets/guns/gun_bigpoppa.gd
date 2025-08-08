extends Node2D

@onready var nodo_rotacion: Node2D = $rotacion
@onready var marcador_apuntado: Marker2D = $rotacion/Sprite2D/Marker2D
@onready var temporizador_disparo: Timer = $Timer
@onready var zona_area2d: Area2D = $Area2D

const escena_proyectil = preload("res://Assets/guns/bullet.tscn")
var tiempo_entre_disparos: float = 0.25

var enemigo_detectado: bool = false
var nodo_jugador: Node2D = null

func _ready() -> void:
	zona_area2d.connect("body_entered", Callable(self, "_on_cuerpo_entrado"))
	zona_area2d.connect("body_exited", Callable(self, "_on_cuerpo_salida"))

	nodo_jugador = get_tree().get_root().get_node("Main/Entities/Player")
	
	temporizador_disparo.wait_time = tiempo_entre_disparos
	temporizador_disparo.one_shot = false
	if not temporizador_disparo.is_connected("timeout", Callable(self, "_on_tiempo_terminado")):
		temporizador_disparo.connect("timeout", Callable(self, "_on_tiempo_terminado"))

func _physics_process(delta: float) -> void:
	if nodo_jugador:
		var angulo_objetivo = (nodo_jugador.global_position - global_position).angle() 
		nodo_rotacion.rotation = lerp_angle(nodo_rotacion.rotation, angulo_objetivo, 6.5 * delta)

func _on_tiempo_terminado() -> void:
	if enemigo_detectado:
		_disparar()

func _on_cuerpo_entrado(body: Node) -> void:
	if body.name == "Player":
		enemigo_detectado = true
		temporizador_disparo.start()

func _on_cuerpo_salida(body: Node) -> void:
	if body.name == "Player":
		enemigo_detectado = false
		temporizador_disparo.stop()

func _disparar():
	var num_proyectiles = 5
	var angulo_variacion = deg_to_rad(15)
	
	for i in num_proyectiles:
		var proyectil_nuevo = escena_proyectil.instantiate()
		proyectil_nuevo.global_position = marcador_apuntado.global_position
		
		var angulo_azar = randf_range(-angulo_variacion, angulo_variacion)
		proyectil_nuevo.rotation = marcador_apuntado.global_rotation + angulo_azar

		get_tree().current_scene.add_child(proyectil_nuevo)

extends Node2D

@onready var rotasion: Node2D = $rotasion
@onready var apuntado: Marker2D = $rotasion/Sprite2D/apuntado
@onready var retorno_de_fuego: Timer = $retorno_de_fuego

const escena_bala = preload("res://Assets/guns/bullet.tscn")
var fire_rate: float = 1.7
var puede_disparar: bool = true

func _ready() -> void:
	retorno_de_fuego.wait_time = fire_rate
	retorno_de_fuego.one_shot = true
	
	if not retorno_de_fuego.is_connected("timeout", Callable(self, "_on_retorno_de_fuego_timeout")):
		retorno_de_fuego.connect("timeout", Callable(self, "_on_retorno_de_fuego_timeout"))

func _physics_process(delta: float) -> void:
	var objetivo_dir = (get_global_mouse_position() - global_position).angle()
	rotasion.rotation = lerp_angle(rotasion.rotation, objetivo_dir, 6.5 * delta)

	if Input.is_action_just_pressed("shoot") and puede_disparar:
		_shoot()
		puede_disparar = false
		retorno_de_fuego.start()

func _shoot():
	var cantidad_balas = 5 
	var angulo_max = deg_to_rad(15)  
	
	for i in cantidad_balas:
		var nueva_bala = escena_bala.instantiate()
		nueva_bala.global_position = apuntado.global_position
		
		
		var angulo_random = randf_range(-angulo_max, angulo_max)
		nueva_bala.rotation = apuntado.global_rotation + angulo_random

		get_tree().current_scene.add_child(nueva_bala)

func _on_retorno_de_fuego_timeout() -> void:
	puede_disparar = true

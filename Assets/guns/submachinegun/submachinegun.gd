extends Node2D

@onready var rotacion: Node2D = $rotacion
@onready var lugar__disparao: Marker2D = $rotacion/Sprite2D/lugar__disparao
@onready var fire_rate: Timer = $fire_rate

const escena_bala = preload("res://Assets/guns/bullet.tscn")
var vel_atck: float = 0.002
var puede_disparar: bool = true

func _ready() -> void:
	add_to_group("player") 
	fire_rate.wait_time = vel_atck
	fire_rate.one_shot = true
	var callback = Callable(self, "_on_fire_rate_timeout")
	if not fire_rate.is_connected("timeout", callback):
		fire_rate.connect("timeout", callback)


func _physics_process(delta: float) -> void:
	var objetivo_dir = (get_global_mouse_position() - global_position).angle()
	rotacion.rotation = lerp_angle(rotacion.rotation, objetivo_dir, 6.5 * delta)

	if Input.is_action_just_pressed("shoot") and puede_disparar:
		_shoot()
		puede_disparar = false
		fire_rate.start()

func _shoot():
	var nueva_bala = escena_bala.instantiate()
	nueva_bala.global_position = lugar__disparao.global_position
	nueva_bala.rotation = lugar__disparao.global_rotation
	get_tree().current_scene.add_child(nueva_bala)
	
func _on_fire_rate_timeout() -> void:
	puede_disparar = true

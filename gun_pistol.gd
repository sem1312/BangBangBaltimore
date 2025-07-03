extends Node2D

@export var attackSpeed=1.0
const bullet=preload("res://bullet_9_mm.tscn")
@onready var marker2d=$Marker2D
@onready var attack_speed_timer=$attack_speed

var canshoot=true


var bulletDirection=Vector2(1,0)

func _ready():
	attack_speed_timer.wait_time = 1.0/attackSpeed
	
func shoot():
	if canshoot:
		canshoot=false
		attack_speed_timer.start()
		var bullet_node=bullet.instantiate()
		bullet_node.set_direction(bulletDirection)
		get_tree().root.add_child(bullet_node)
		bullet_node.global_position=marker2d.global_position 
		



func _on_attack_speed_timeout() -> void:
	canshoot=true
	
func setup_direction(direction):
	bulletDirection=direction
	
	if direction.x > 0:
		scale.x = 1
		rotation_degrees = 0
	elif direction.x < 0:
		scale.x = -1
		rotation_degrees = 180
	elif direction.y > 0:
		scale.x=1
		rotation_degrees=-90
	elif direction.y < 0:
		scale.x=1
		rotation_degrees=90
		

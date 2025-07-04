extends Node2D

@export var attackSpeed = 1.0
const bullet = preload("res://bullet_9_mm.tscn")

@onready var marker2d: Marker2D = $Marker2D
@onready var attack_speed_timer: Timer = $attack_speed
@onready var sprite: Sprite2D = $Sprite2D  # Make sure your gun has a Sprite2D child node

var can_shoot := true
var bullet_direction := Vector2.RIGHT

func _ready():
	attack_speed_timer.wait_time = 1.0 / attackSpeed

func shoot():
	if can_shoot:
		can_shoot = false
		attack_speed_timer.start()
		var bullet_node = bullet.instantiate()
		bullet_node.set_direction(bullet_direction)
		get_tree().root.add_child(bullet_node)
		bullet_node.global_position = marker2d.global_position

func _on_attack_speed_timeout():
	can_shoot = true

func setup_direction(direction: Vector2):
	bullet_direction = direction.normalized()

	# Rotate & flip sprite depending on direction
	if abs(direction.x) > abs(direction.y):
		# Horizontal aim
		sprite.rotation_degrees = 0
		sprite.flip_h = direction.x > 0
	else:
		# Vertical aim
		sprite.rotation_degrees = 90 if direction.y < 0 else -90  
		sprite.flip_h = false

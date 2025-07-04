extends CharacterBody2D

var speed := 200
@onready var sprite := $AnimatedSprite2D
var last_direction := "down"  # Para saber hacia dónde quedó mirando
@onready var gun := $gun
func _ready():
	global_position = get_viewport().get_visible_rect().size / 2
	
	if get_tree().get_root().has_node("MusicPlayer"):
		get_tree().get_root().get_node("MusicPlayer").queue_free()

func _physics_process(delta):
	var direction := Vector2.ZERO
	if Input.is_action_pressed("shoot"): #mapa de entrada ->shoot -> k 
		gun.shoot()
		
	if direction != Vector2.ZERO:
		gun.setup_direction(direction)
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1
	
	velocity = direction.normalized() * speed
	move_and_slide()
	
	if direction != Vector2.ZERO:
		gun.setup_direction(direction.normalized())
		
	# Animaciones según dirección
	if direction != Vector2.ZERO:
		if direction.y > 0:
			last_direction = "down"
			if sprite.animation != "walk_down":
				sprite.play("walk_down")
		elif direction.y < 0:
			last_direction = "up"
			if sprite.animation != "walk_up":
				sprite.play("walk_up")
		elif direction.x < 0:
			last_direction = "left"
			if sprite.animation != "walk_left":
				sprite.play("walk_left")
		elif direction.x > 0:
			last_direction = "right"
			if sprite.animation != "walk_right":
				sprite.play("walk_right")
	else:
		var idle_anim := "idle_" + last_direction
		if sprite.animation != idle_anim:
			sprite.play(idle_anim)
@export var lastdihrection=last_direction

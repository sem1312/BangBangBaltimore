extends CharacterBody2D

var speed := 200

func _ready():
	global_position = get_viewport().get_visible_rect().size / 2

func _physics_process(delta):
	var direction := Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	velocity = direction.normalized() * speed
	move_and_slide()

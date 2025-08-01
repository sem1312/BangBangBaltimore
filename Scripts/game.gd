extends CharacterBody2D

var speed := 200
@onready var sprite := $AnimatedSprite2D
var last_direction := "down"
var vida: int = 5


func _ready():
	add_to_group("player")
	global_position = get_viewport().get_visible_rect().size / 2

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var paused = get_tree().paused
		get_tree().paused = not paused
		get_node("/root/Main/PauseMenu").visible = not paused
		print("Player visible:", visible)
		print("Player position: ", position)

func _physics_process(_delta):
	var direction := Vector2.ZERO
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



func take_damage(cantidad: int = 1) -> void:
	vida -= cantidad
	print("¡Me dieron! Vida restante:", vida)

	if vida <= 0:
		die()

func die() -> void:
	print("¡Muerto!")
	queue_free()

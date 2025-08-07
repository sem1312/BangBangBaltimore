extends CharacterBody2D

var enemies = 8
var speed := 200
@onready var sprite := $AnimatedSprite2D
@onready var exit_zone := get_node("/root/Main/ExitZone")
@onready var especial := get_node("/root/Main/ExitZone/Especial")
@onready var parking_message := get_node("/root/Main/CanvasLayer/Panel/Label")
@onready var panel := get_node("/root/Main/CanvasLayer/Panel")


var last_direction := "down"
var puede_salir := false
var vida: int = 100000

func _ready():
	add_to_group("player")
	global_position = get_viewport().get_visible_rect().size / 2
	exit_zone.visible = false
	exit_zone.monitoring = false

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

func enemy_muerto():
	enemies -= 1
	print("Enemigos restantes: ", enemies)
	
	if enemies <= 0:
		print("¡Todos los enemigos fueron derrotados!")
		exit_zone.visible = true
		exit_zone.monitoring = true
		puede_salir = true
		parking_message.visible = true
		especial.visible = true
		panel.visible = true
		
		
		await get_tree().create_timer(7.0).timeout
		parking_message.visible = false
		panel.visible = false

func take_damage(cantidad: int = 1) -> void:
	vida -= cantidad
	print("¡Me dieron! Vida restante:", vida)

	if vida <= 0:
		die()

func die() -> void:
	print("¡Muerto!")
	queue_free()

func _on_exit_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.puede_salir:
		print("¡Entraste al parking!")

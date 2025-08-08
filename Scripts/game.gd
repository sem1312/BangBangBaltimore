extends CharacterBody2D

var enemies = 8
var speed := 200
var weapon_state := 0  # Estado del arma activa
var active_weapon: Node = null

@onready var sprite := $AnimatedSprite2D
@onready var exit_zone := get_node("/root/Main/ExitZone")
@onready var especial := get_node("/root/Main/ExitZone/Especial")
@onready var parking_message := get_node("/root/Main/CanvasParking/Panel/Label")
@onready var panel := get_node("/root/Main/CanvasParking/Panel")
@onready var parking_message2 := get_node("/root/Main/CanvasParking2/Panel/Label")
@onready var panel2 := get_node("/root/Main/CanvasParking2/Panel")
@onready var health_bar := get_node_or_null("/root/Main/UI/HealthBar")
@onready var health_label := get_node_or_null("/root/Main/UI/HealthLabel")
@onready var game_over_label := get_node_or_null("/root/Main/UI/GameOverLabel")
@onready var restart_button := get_node_or_null("/root/Main/UI/RestartButton")

@onready var weapon_slot := $weapon_slot

@onready var weapons := [
	$gun_9mm,
	$escopeta,
	$submachinegun_player
]

var last_direction := "down"
var puede_salir := false
var vida: int = 500
var max_vida: int = vida
var muerto := false
var inside_exit_zone := false

func _ready():
	add_to_group("player")
	global_position = get_viewport().get_visible_rect().size / 2

	if health_bar:
		health_bar.min_value = 0
		health_bar.max_value = max_vida
		health_bar.value = clamp(vida, 0, max_vida)
	if health_label:
		_update_health_label()

	exit_zone.visible = false
	exit_zone.monitoring = false

	if game_over_label:
		game_over_label.visible = false
	if restart_button:
		restart_button.visible = false
	
	exit_zone.connect("body_entered", Callable(self, "_on_exit_zone_body_entered"))
	exit_zone.connect("body_exited", Callable(self, "_on_exit_zone_body_exited"))

	_set_weapon_state(weapon_state)

func _input(event):
	if muerto:
		return

	if event.is_action_pressed("ui_cancel"):
		var paused = get_tree().paused
		get_tree().paused = not paused
		get_node("/root/Main/PauseMenu").visible = not paused
		print("Player visible:", visible)
		print("Player position: ", position)

func _physics_process(_delta):
	if muerto:
		return

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

	# Cambiar arma con R
	if Input.is_action_just_pressed("r"):
		weapon_state = (weapon_state + 1) % weapons.size()
		_set_weapon_state(weapon_state)

func _set_weapon_state(state: int) -> void:
	for i in range(weapons.size()):
		if i == state:
			if not weapons[i].is_inside_tree():
				weapon_slot.add_child(weapons[i])
			weapons[i].visible = true
			weapons[i].set_process(true)
			weapons[i].set_physics_process(true)
			weapons[i].position = Vector2.ZERO
			weapons[i].rotation = 0
			weapons[i].scale = Vector2.ONE
		else:
			if weapons[i].is_inside_tree():
				weapons[i].get_parent().remove_child(weapons[i])
			weapons[i].visible = false
			weapons[i].set_process(false)
			weapons[i].set_physics_process(false)

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
	if muerto:
		return

	vida -= cantidad
	vida = clamp(vida, 0, max_vida)
	_update_health_ui()
	print("¡Me dieron! Vida restante:", vida)

	if vida <= 0:
		die()

func _update_health_ui() -> void:
	if health_bar:
		health_bar.value = clamp(vida, 0, max_vida)
	if health_label:
		_update_health_label()

func _update_health_label() -> void:
	if health_label:
		var total_barras = 10
		var barras_llenas = int((float(vida) / max_vida) * total_barras)
		var barras_vacias = total_barras - barras_llenas
		var barra = "█".repeat(barras_llenas) + "░".repeat(barras_vacias)
		health_label.text = "Vida: %d %s" % [vida, barra]

func die() -> void:
	muerto = true
	game_over_label.text = "GAME OVER"
	game_over_label.visible = true
	restart_button.visible = true
	print("¡Muerto!")

	sprite.visible = false
	self.set_collision_layer(0)
	self.set_collision_mask(0)
	get_tree().paused = true

func _on_exit_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		inside_exit_zone = true
		body.inside_exit_zone = true
		print("Jugador entró a ExitZone")


	if body.is_in_group("player") and body.puede_salir:
		print("¡Entraste al parking!")
		parking_message2.visible = true
		panel2.visible = true

		await get_tree().create_timer(5.0).timeout
		parking_message2.visible = false
		panel2.visible = false

func _on_exit_zone_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		inside_exit_zone = false
		body.inside_exit_zone = false
		print("Jugador salió de ExitZone")

	parking_message2.visible = true
	panel2.visible = true

	await get_tree().create_timer(5.0).timeout
	parking_message2.visible = false
	panel2.visible = false

func _on_restart_button_pressed() -> void:
	print("Botón reiniciar presionado")
	get_tree().paused = false
	get_tree().reload_current_scene()

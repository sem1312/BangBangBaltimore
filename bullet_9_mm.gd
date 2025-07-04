extends Area2D

@export var speed = 600
@export var damage = 10

var direction: Vector2 = Vector2.ZERO

func _ready():
	await get_tree().create_timer(3.0).timeout
	queue_free()

func set_direction(bullet_direction: Vector2):
	direction = bullet_direction.normalized()
	rotation = direction.angle()

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigo"):
		body.get_damage(damage)
		queue_free()

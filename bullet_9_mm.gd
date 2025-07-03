extends Area2D


@export var speed=600
@export var damage=10

var direction: Vector2
func _ready():
	await get_tree().create_timer(3).timeout
	queue_free()
	
func set_direction (bullet_direccion):

	direction=bullet_direccion
	rotation=rad_to_deg(global_position.angle_to_point(global_position+direction))

func _physics_process(delta):
	global_position += direction*speed*delta
	
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigo"):
		body.get_damage(damage)
		queue_free()
		
		
	

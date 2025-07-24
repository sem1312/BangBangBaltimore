extends Sprite2D

@onready var RayCast: RayCast2D = $RayCast2D

var speed: float = 750

func _ready():
	RayCast.enabled = true

func _physics_process(delta: float) -> void:
	global_position += Vector2(1, 0).rotated(rotation) * speed * delta

	if RayCast.is_colliding():
		var collider = RayCast.get_collider()
		if collider and not collider.is_in_group("player"):
			queue_free()

func _on_distancia_timeout() -> void:
	queue_free()

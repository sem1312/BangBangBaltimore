extends Sprite2D

@onready var RayCast: RayCast2D = $RayCast2D

var speed: float = 10

func _physics_process(delta: float) -> void:
	global_position += Vector2(1, 0).rotated(rotation) * speed * delta
	
	if RayCast.is_colliding():
		var collider = RayCast.get_collider()
		if collider:
			var is_player = collider.has("Is_player") and collider.get("Is_player")
			if !is_player:
				queue_free()


func _on_distancia_timeout() -> void:
	queue_free()

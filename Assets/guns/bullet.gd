extends Sprite2D

@onready var RayCast: RayCast2D = $RayCast2D

var speed: float = 750
var player = null 
var angle_degrees = fposmod(rad_to_deg(rotation), 360)


func _ready():
	RayCast.enabled = true
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta: float) -> void: 
	global_position += Vector2(1, 0).rotated(rotation) * speed * delta

	if RayCast.is_colliding():
		var collider = RayCast.get_collider()
		
		# Condición para hacer el print si:
		# - player está dentro del ExitZone
		# - no quedan enemigos
		# - ángulo del disparo está entre 75 y 105 grados
		if player != null:
			if player.inside_exit_zone and player.enemies == 0:
				var angle_degrees = rad_to_deg(rotation)
				if angle_degrees > 255 and angle_degrees < 285:
					print("Disparaste hacia arriba dentro del ExitZone y sin enemigos")

		if collider and collider.has_method("take_damage"):
			collider.take_damage(1)

		queue_free()

func _on_distancia_timeout() -> void:
	queue_free()

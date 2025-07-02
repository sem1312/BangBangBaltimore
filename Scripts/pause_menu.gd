extends CanvasLayer  # o Control si tu PauseMenu es de ese tipo

@onready var resume_button := $ResumeButton  # Asegurate que se llame así

func _ready():
	resume_button.pressed.connect(_on_resume_button_pressed)

func _on_resume_button_pressed() -> void:
	print("REANUDANDO JUEGO")
	get_tree().paused = false
	visible = false
	var cam = get_node_or_null("/root/Main/Player/Camera2D")
	if cam:
		cam.make_current()
	else:
		print("❌ No se encontró la cámara")

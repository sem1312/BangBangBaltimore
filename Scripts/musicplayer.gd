extends Node

@onready var player := $AudioStreamPlayer
var current_track := ""

func play_music(path: String):
	print("play_music llamado con ", path)
	if player.stream and player.stream.resource_path == path:
		return
	player.stop()
	player.stream = load(path)
	player.play()

func set_music_volume(value: float) -> void:
	var volume_db = linear_to_db(value / 100.0)
	player.volume_db = volume_db

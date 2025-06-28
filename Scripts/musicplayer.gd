extends Node

func set_music_volume(value):
	var volume_db = linear_to_db(value / 100.0)
	var player = get_tree().get_root().get_node("MusicPlayer").get_node("AudioStreamPlayer")
	player.volume_db = volume_db

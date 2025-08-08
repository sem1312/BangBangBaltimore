extends Control

func _ready() -> void:
	if not get_tree().get_root().has_node("MusicPlayer"):
		var music_scene = load("res://Scenes/MusicPlayer.tscn").instantiate()
		music_scene.name = "MusicPlayer"
		get_tree().get_root().call_deferred("add_child", music_scene)

		await get_tree().process_frame  # Espera a que se agregue al árbol

		var music_player = get_tree().get_root().get_node("MusicPlayer")
		music_player.play_music("res://Audio/bigpoppa.mp3")
	else:
		var music_player = get_tree().get_root().get_node("MusicPlayer")
		music_player.play_music("res://Audio/bigpoppa.mp3")

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

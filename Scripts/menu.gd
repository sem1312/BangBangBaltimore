extends Control

func _ready() -> void:
	if not get_tree().get_root().has_node("MusicPlayer"):
		var music_scene = load("res://Scenes/MusicPlayer.tscn").instantiate()
		music_scene.name = "MusicPlayer"
		get_tree().get_root().call_deferred("add_child", music_scene)

		await get_tree().process_frame  # Espera a que se agregue al árbol

		# Fuerza reproducción por si autoplay falla
		var player = music_scene.get_node("AudioStreamPlayer")
		player.play()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

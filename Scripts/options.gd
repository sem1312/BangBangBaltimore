extends Control

var vbox
var panel_volume
var panel_resolution
var resolution_label

var current_resolution = Vector2i(1920, 1080)

func _ready():
	vbox = $VBoxContainer
	panel_volume = $PanelVolume
	panel_resolution = $PanelResolution
	resolution_label = get_node("PanelResolution/VBoxContainer/ResolutionLabel")

	panel_volume.visible = false
	panel_resolution.visible = false
	resolution_label.visible = false
	
	var vb = panel_resolution.get_node("VBoxContainer")
	vb.get_node("Label").text = "Resolución actual:"
	vb.get_node("BtnResolution").text = "%dx%d" % [current_resolution.x, current_resolution.y]

	vb.get_node("BtnResolution").pressed.connect(_on_btn_resolution_pressed)
	vb.get_node("PopupResolutions").connect("id_pressed", Callable(self, "_on_resolution_selected"))

	var options = ["1280x720", "1920x1080", "Fullscreen"]
	for i in range(options.size()):
		vb.get_node("PopupResolutions").add_item(options[i], i)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_volume_pressed() -> void:
	toggle_panel(panel_volume)

func _on_resolution_pressed() -> void:
	toggle_panel(panel_resolution)

func toggle_panel(panel: Node) -> void:
	var show_panel = not panel.visible
	panel.visible = show_panel
	vbox.get_node("Volume").visible = not show_panel
	vbox.get_node("Resolution").visible = not show_panel
	vbox.get_node("Back").visible = not show_panel

	# Ocultar el otro panel si se está mostrando
	if panel == panel_volume:
		panel_resolution.visible = false
	elif panel == panel_resolution:
		panel_volume.visible = false


func _on_HSlider_value_changed(value: float) -> void:
	var volumen_db = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volumen_db)


func _on_btn_resolution_pressed():
	var btn = panel_resolution.get_node("VBoxContainer/BtnResolution")
	var popup = panel_resolution.get_node("VBoxContainer/PopupResolutions")
	var pos = btn.get_global_position()
	popup.popup(Rect2(pos, Vector2.ZERO))

func _on_resolution_selected(id):
	match id:
		0:
			_set_resolution(Vector2i(1280, 720))
		1:
			_set_resolution(Vector2i(1920, 1080))
		2:
			_set_fullscreen()

func _set_resolution(new_size: Vector2i):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(new_size)
	current_resolution = new_size
	panel_resolution.get_node("VBoxContainer/BtnResolution").text = "%dx%d" % [new_size.x, new_size.y]
	
func _set_fullscreen():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	current_resolution = Vector2i(0, 0)
	panel_resolution.get_node("VBoxContainer/BtnResolution").text = "Fullscreen"

func show_resolution_message(text: String):
	resolution_label.text = text
	resolution_label.visible = true
	await get_tree().create_timer(2.0).timeout
	resolution_label.visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if panel_volume.visible or panel_resolution.visible:
			panel_volume.visible = false
			panel_resolution.visible = false
			vbox.get_node("Volume").visible = true
			vbox.get_node("Resolution").visible = true
			vbox.get_node("Back").visible = true
		else:
			_on_back_pressed()

extends VBoxContainer

# SETTINGS FILE
var config = ConfigFile.new()

# VALUES
var brightnessLevel := 0.45

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Mosquit v. 0.0.1")
	
	if(Input.mouse_mode == Input.MOUSE_MODE_HIDDEN):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Load data from a file.
	var err = config.load("user://config.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		return
		
	# Iterate over all sections
	for section in config.get_sections():
		brightnessLevel = config.get_value(section, "brightnessLevel")

	$Brightness.set_color(Color(brightnessLevel, brightnessLevel, brightnessLevel, 255))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_new_game_mouse_entered() -> void:
	$New_Game.label_settings.font_color = Color.ORANGE


func _on_tutorial_mouse_entered() -> void:
	$Tutorial.label_settings.font_color = Color.ORANGE


func _on_settings_mouse_entered() -> void:
	$Settings.label_settings.font_color = Color.ORANGE


func _on_exit_mouse_entered() -> void:
	$Exit.label_settings.font_color = Color.ORANGE


func _on_new_game_mouse_exited() -> void:
	$New_Game.label_settings.font_color = Color.WHITE


func _on_tutorial_mouse_exited() -> void:
	$Tutorial.label_settings.font_color = Color.WHITE


func _on_settings_mouse_exited() -> void:
	$Settings.label_settings.font_color = Color.WHITE


func _on_exit_mouse_exited() -> void:
	$Exit.label_settings.font_color = Color.WHITE


func _on_new_game_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.


func _on_tutorial_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene_to_file("res://scenes/game/world.tscn")


func _on_settings_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene_to_file("res://scenes/menu/settings.tscn")

func _on_exit_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().quit()

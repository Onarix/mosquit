extends Node2D

# SETTINGS FILE
var config = ConfigFile.new()

# VALUES
var brightnessLevel := 0.45

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load data from a file.
	var err = config.load("user://config.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		return
		
	# Iterate over all sections
	for section in config.get_sections():
		brightnessLevel = config.get_value(section, "brightnessLevel")
	
	$Shadow.set_color(Color(brightnessLevel, brightnessLevel, brightnessLevel, 255))
	$Content/VBoxContainer/Options/Brightness/BrightnessControl/BrightnessSlider.set_value_no_signal(brightnessLevel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_brightness_slider_value_changed(value: float) -> void:
	brightnessLevel = $Content/VBoxContainer/Options/Brightness/BrightnessControl/BrightnessSlider.value
	$Shadow.set_color(Color(brightnessLevel, brightnessLevel, brightnessLevel, 255))
	config.set_value("SETTINGS", "brightnessLevel", brightnessLevel)

func _on_back_mouse_entered() -> void:
	$Content/VBoxContainer/Back.label_settings.font_color = Color.ORANGE

func _on_back_mouse_exited() -> void:
	$Content/VBoxContainer/Back.label_settings.font_color = Color.WHITE

func _on_back_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		config.save("user://config.cfg")
		get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")

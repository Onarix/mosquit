extends Node2D

# SETTINGS FILE
var config = ConfigFile.new()

# VALUES
var brightnessLevel := 0.45

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Player.position_changed.connect($Enemy._on_player_position_changed)
	
	# Load data from a file.
	var err = config.load("user://config.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		return
		
	# Iterate over all sections
	for section in config.get_sections():
		brightnessLevel = config.get_value(section, "brightnessLevel")

	$Shadow.set_color(Color(brightnessLevel, brightnessLevel, brightnessLevel, 255))
	
func _input(event) -> void:
	if(event.is_action_pressed("Back")):
		get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

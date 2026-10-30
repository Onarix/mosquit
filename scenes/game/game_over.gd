extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Content.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_game_over() -> void:
	if(Input.mouse_mode == Input.MOUSE_MODE_HIDDEN):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	var redScreenTween = create_tween()
	redScreenTween.tween_property($RedScreen, "color", Color(143 / 255.0, 0, 0, 1.0), 3.0)
	
	redScreenTween.tween_property($Content, "visible", true, 1.0)


func _on_new_game_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().paused = false
		get_tree().reload_current_scene()


func _on_new_game_mouse_entered() -> void:
	$Content/VBoxContainer/Options/New_Game.label_settings.font_color = Color.ORANGE


func _on_new_game_mouse_exited() -> void:
	$Content/VBoxContainer/Options/New_Game.label_settings.font_color = Color.WHITE


func _on_return_to_menu_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_return_to_menu_mouse_entered() -> void:
	$Content/VBoxContainer/Options/Return_to_menu.label_settings.font_color = Color.ORANGE


func _on_return_to_menu_mouse_exited() -> void:
	$Content/VBoxContainer/Options/Return_to_menu.label_settings.font_color = Color.WHITE

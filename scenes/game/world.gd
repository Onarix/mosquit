extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#var new_enemy = load("res://scenes/game/enemy.tscn").instantiate()
	$Player.position_changed.connect($Enemy._on_player_position_changed)
	#get_parent().add_child.call_deferred(new_enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

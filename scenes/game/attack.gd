extends Area2D

var isAttacking := false

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	isAttacking = not isAttacking
	$Range.disabled = not $Range.disabled
	

func _input(event):
	if(event.is_action_pressed("LMB") and not isAttacking):
		var swing = create_tween()
		isAttacking = not isAttacking
		$Range.disabled = not $Range.disabled
		swing.tween_property($".", "scale", get_parent().get_parent().max_range, get_parent().get_parent().attSpeed)
		swing.tween_property($".", "scale", Vector2(0.0, 0.0), 0.1)
		wait(get_parent().get_parent().cooldown)
		
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

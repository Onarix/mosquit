extends TextureProgressBar

func update(updatedHealth) -> void:
	var healthTween = create_tween()
	healthTween.tween_property($".", "value", updatedHealth, 0.5)
	#value = updatedHealth

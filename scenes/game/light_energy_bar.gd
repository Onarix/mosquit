extends TextureProgressBar

func update(updatedEnergy) -> void:
	var energyTween = create_tween()
	energyTween.tween_property($".", "value", updatedEnergy, 0.5)

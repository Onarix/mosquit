extends CanvasLayer

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.health_changed.connect(updateHealthBar)
	player.lightEnergy_changed.connect(updateLightEnergyBar)
	updateHealthBar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func updateHealthBar():
	var newHealth = player.health
	$HealthBar.update(newHealth)

func updateLightEnergyBar():
	var newEnergy = player.flashlightEnergy 
	$LightEnergyBar.update(newEnergy)
		

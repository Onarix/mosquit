extends CharacterBody2D

# STATS
# base
@export var level := 1
@export var experience := 0
@export var speed := 40
@export var health := 100
@export var sanity := 100
@export var flashlightEnergy := 100

# attack
@export var attSpeed := 2.0
@export var cooldown := 0.1
@export var max_range := Vector2(2.0, 2.0)
@export var attAngle := 45.0
@export var knockback := 3.0

# MISC
var left := false
var mouse_pos := Vector2(0, 0)
var turn_dir := {true: 1, false: -1}
var isHit := false
var weight := 0.1
var rotation_direction := 0

@onready var _animated_sprite = $Body/AnimatedSprite2D

signal position_changed(position)

func _input(event):
	mouse_pos = get_global_mouse_position()
	var input_direction = Vector2.ZERO
	
	# MOVEMENT
	if(not isHit):
		input_direction = Input.get_vector("left", "right", "up", "down")
		
		# FLASHLIGHT
		if((left == false and mouse_pos.x >= self.position.x) or (left == true and mouse_pos.x <= self.position.x)):
			$Flashlight.look_at(mouse_pos)
		else:
			left = not left
			scale = Vector2(-1 * scale.x, scale.y)
			get_viewport().warp_mouse(Vector2(self.get_global_transform_with_canvas().origin.x - turn_dir[left] * abs(self.get_global_transform_with_canvas().origin.x - mouse_pos.x), mouse_pos.y)) 
		
		if(event.is_action_pressed("Flashlight toggle")):
			$Flashlight.enabled = not $Flashlight.enabled
			$Flashlight/Lightfield/CollisionPolygon2D.disabled = not $Flashlight/Lightfield/CollisionPolygon2D.disabled
		
		# ANIMATION
		if(Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("up") or Input.is_action_pressed("right")):
			_animated_sprite.play("walk")
		else:
			_animated_sprite.stop()
		
	velocity = input_direction * speed

# PHYSICS
func _physics_process(_delta):
	emit_signal("position_changed", self.global_position)
	
	if(isHit):
		self.velocity = lerp(self.velocity, Vector2(0.0, 0.0), weight)
	
	move_and_slide()

# ATTACK ENEMY COOLDOWN
func wait_for_enemy(enemy: CharacterBody2D) -> void:
		await get_tree().create_timer(cooldown).timeout
		enemy.rotation = lerp(enemy.rotation, enemy.angles[0] , enemy.weight)
		enemy.isHit = not enemy.isHit

# ATTACK
func _on_attack_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Enemy")):
		var angle = $Flashlight.rotation
		var enemy = area.get_parent()
		wait_for_enemy(enemy)
		enemy.velocity = Vector2(turn_dir[not left] * cos(angle), sin(angle)) * knockback
		enemy.isHit = not enemy.isHit

# DAMAGE DEAL
func _on_damage_body_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Enemy")):
		var enemy = area.get_parent()
		self.velocity = enemy.velocity * enemy.knockback
		self.modulate = Color.ORANGE_RED
		if(not isHit):
			isHit = not isHit
		print("HIT: ", isHit)
		$StunTime.start()

func _on_stun_time_timeout() -> void:
	if(isHit):
		isHit = not isHit
	print("END: ", isHit)
	self.modulate = Color.WHITE
	$StunTime.stop()

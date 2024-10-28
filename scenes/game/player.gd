extends CharacterBody2D

@export var speed := 40
@export var rotation_speed := 1.5
var left := false
var mouse_pos := Vector2(0, 0)
var turn_dir := {true: 1, false: -1}

# Attack fields
@export var attSpeed := 2.0
@export var cooldown := 0.1
@export var max_range := Vector2(2.0, 2.0)
@export var attAngle := 45.0
@export var knockback := 3.0

var rotation_direction := 0

signal position_changed(position)

func _input(event):
	mouse_pos = get_global_mouse_position()
	if((left == false and mouse_pos.x >= self.position.x) or (left == true and mouse_pos.x <= self.position.x)):
		$Flashlight.look_at(mouse_pos)
	else:
		left = not left
		scale = Vector2(-1 * scale.x, scale.y)
		get_viewport().warp_mouse(Vector2(self.get_global_transform_with_canvas().origin.x - turn_dir[left] * abs(self.get_global_transform_with_canvas().origin.x - mouse_pos.x), mouse_pos.y)) 
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if(event.is_action_pressed("Flashlight toggle")):
		$Flashlight.enabled = not $Flashlight.enabled
		$Flashlight/Lightfield/CollisionPolygon2D.disabled = not $Flashlight/Lightfield/CollisionPolygon2D.disabled
		

	velocity = input_direction * speed
	
	

func _physics_process(_delta):
	emit_signal("position_changed", self.global_position)
	move_and_slide()


func wait_for_enemy(enemy: CharacterBody2D) -> void:
		await get_tree().create_timer(cooldown).timeout
		enemy.rotation = lerp(enemy.rotation, enemy.angles[0] , enemy.weight)
		enemy.isHit = not enemy.isHit

func _on_attack_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Enemy")):
		var angle = $Flashlight.rotation
		var enemy = area.get_parent()
		wait_for_enemy(enemy)
		enemy.velocity = Vector2(turn_dir[not left] * cos(angle), sin(angle)) * knockback
		enemy.isHit = not enemy.isHit

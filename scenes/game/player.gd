extends CharacterBody2D

@export var speed = 40
@export var rotation_speed = 1.5
var left = false
var mouse_pos = Vector2(0, 0)
var turn_dir = {true: 1, false: -1}

# Attack fields
@export var attSpeed = 2.0
@export var cooldown = 0.1
@export var max_range = Vector2(2.0, 2.0)
@export var attAngle = 45.0
@export var knockback = Vector2(3.0, 3.0)

var rotation_direction = 0

func _input(event):
	mouse_pos = get_global_mouse_position()
	$Flashlight.look_at(mouse_pos if ((left == false and mouse_pos.x >= self.position.x) or (left == true and mouse_pos.x <= self.position.x)) else Vector2(self.position.x, mouse_pos.y))
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if(event.is_action_pressed("Flashlight toggle")):
		$Flashlight.enabled = not $Flashlight.enabled
		

	if((event.is_action_pressed("left") and left == false) or (event.is_action_pressed("right") and left == true)):
		left = not left
		scale = Vector2(-1 * scale.x, scale.y)
		get_viewport().warp_mouse(Vector2(self.get_global_transform_with_canvas().origin.x - turn_dir[left] * abs(self.get_global_transform_with_canvas().origin.x - mouse_pos.x), mouse_pos.y)) 
				
	velocity = input_direction * speed
	
	

func _physics_process(delta):
	move_and_slide()


func _on_attack_area_entered(area: Area2D) -> void:
	if(area.is_in_group("Enemy")):
		area.get_parent().apply_force(knockback, area.get_parent().position)

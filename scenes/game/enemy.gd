extends CharacterBody2D

# STATS
@export var speed := 500.0
@export var weight := 0.2
@export var knockback := 12.0

# MISC
const angles := [deg_to_rad(-25.0), deg_to_rad(25.0)]
const negative_positive = [-1, 1]
const maxHeight := 15.0
const coeff := 0.5
var height := 0.01
var start_pos := Vector2(0,0)
var direction := Vector2.DOWN
var isHit := false
var isAttracted := false
var isRandomMoving := false
var random_dir := Vector2(0,0) 
var player_pos := Vector2(0,0)

@onready var nav: NavigationAgent2D = $NavigationAgent2D


# NOT ATTRACTED
func turn() -> void:
	self.rotation = angles[randi() % 2]
	
func moveRandom() -> void:
	isRandomMoving = not isRandomMoving
	random_dir = Vector2(negative_positive[randi() % negative_positive.size()] * randf_range(0.0 ,pow(speed, 2.0)), negative_positive[randi() % negative_positive.size()] * randf_range(0.0 ,pow(speed, 2.0)))
	await get_tree().create_timer(1.0).timeout
	isRandomMoving = not isRandomMoving
	#print(self.velocity)

func pulse() -> void:
	self.velocity += speed * direction * coeff
	height = abs(self.position.y - start_pos.y) 
	if(height >= maxHeight):
		self.velocity = Vector2(0, 0)
		start_pos = self.position
		direction *= -1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_pos = self.position
	$Turn.start()
	$MoveRandom.start()
	turn()

# PHYSICS
func _process(_delta: float) -> void:
	self.velocity = lerp(self.velocity, Vector2(0.0, 0.0), weight)
	if(not isHit):
		pulse()
	else:
		self.rotation = lerp(self.rotation, deg_to_rad(45.0), weight)

	# ATTRACTED
	if(isAttracted):
		nav.target_position = player_pos
		if(not isHit):
			self.velocity = Vector2(nav.get_next_path_position() - self.global_position).normalized() * speed * 2

	# RANDOM MOVING
	if(isRandomMoving):
		self.velocity = random_dir
		
	move_and_slide()

# RANDOM TURN (CHANGE SIDE)
func _on_timer_timeout() -> void:
	if(not isHit):
		self.velocity = Vector2(0, 0)
		turn()
		$Turn.start()

func _on_move_random_timeout() -> void:
	if(not isHit and not isAttracted):
		moveRandom()
		$MoveRandom.start()

# LIGHT ATTRACTION
func _on_area_2d_area_entered(area: Area2D) -> void:
	$AttractionTime.stop()
	if(area.is_in_group("Light")):
		if(not isAttracted):
			isAttracted = not isAttracted
		var target_pos = area.get_parent().get_parent().position
		$Path/Checker.shape.set_length(self.position.distance_to(target_pos))
		$Path/Checker.look_at(target_pos)
		$Path/Checker.rotation -= deg_to_rad(90)
		
	#print("Enter: ",isAttracted)

func _on_path_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Walls")):
		if(isAttracted):
			isAttracted = not isAttracted

func _on_attraction_time_timeout() -> void:
	if(isAttracted):
		isAttracted = not isAttracted
	$AttractionTime.stop()
	#print("Timeout: ",isAttracted)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if(area.is_in_group("AttractionCircle")):
		$AttractionTime.start()
		$Path/Checker.shape.set_length(0.01)
		$Path/Checker.rotation = deg_to_rad(0)
		#print("Exit: ",isAttracted)
	
# Get Player Position
func _on_player_position_changed(player_new_position: Vector2) -> void:
	player_pos = player_new_position
	

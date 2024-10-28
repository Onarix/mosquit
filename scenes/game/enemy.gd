extends CharacterBody2D

var angles := [deg_to_rad(-25.0), deg_to_rad(25.0)]
const maxHeight := 15.0
const coeff := 0.5
var height := 0.01
var start_pos := Vector2(0,0)
@export var speed := 500.0
@export var weight := 0.2
var direction := Vector2.DOWN
var isHit := false
var isAttracted := false
var player_pos := Vector2(0,0)

@onready var nav: NavigationAgent2D = $NavigationAgent2D

func turn() -> void:
	self.rotation = angles[randi() % 2]
	

func moveRandom() -> void:
	self.velocity = Vector2(randf() * pow(speed, 2.0), randf() * pow(speed, 2.0))

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.velocity = lerp(self.velocity, Vector2(0.0, 0.0), weight)
	if(not isHit):
		pulse()
	else:
		self.rotation = lerp(self.rotation, deg_to_rad(45.0), weight)

	if(isAttracted):
		nav.target_position = player_pos
		self.velocity = Vector2(nav.get_next_path_position() - self.global_position).normalized() * speed * 2

	move_and_slide()
	


func _on_timer_timeout() -> void:
	if(not isHit):
		self.velocity = Vector2(0, 0)
		turn()
		$Turn.start()

# Light attraction
func _on_area_2d_area_entered(area: Area2D) -> void:
	$AttractionTime.stop()
	if(area.is_in_group("Light")):
		if(not isAttracted):
			isAttracted = not isAttracted
		var target_pos = area.get_parent().get_parent().position
		$Path/Checker.shape.set_length(self.position.distance_to(target_pos))
		$Path/Checker.look_at(target_pos)
		$Path/Checker.rotation -= deg_to_rad(90)
		
	print("Enter: ",isAttracted)


func _on_path_body_entered(body: Node2D) -> void:
	if(body.is_in_group("Walls")):
		if(isAttracted):
			isAttracted = not isAttracted


func _on_move_random_timeout() -> void:
	if(not isHit and not isAttracted):
		moveRandom()
		$MoveRandom.start()


func _on_attraction_time_timeout() -> void:
	if(isAttracted):
		isAttracted = not isAttracted
	$AttractionTime.stop()
	print("Timeout: ",isAttracted)

func _on_area_2d_area_exited(area: Area2D) -> void:
	$AttractionTime.start()
	$Path/Checker.shape.set_length(0.01)
	$Path/Checker.rotation = deg_to_rad(0)
	print("Exit: ",isAttracted)
	
func _on_player_position_changed(player_new_position: Vector2) -> void:
	player_pos = player_new_position
	
	
	

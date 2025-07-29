class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var move_speed : float = 100.0
var state : String = "idle"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D



func _ready():
	pass
	
	
func _process(delta: float):
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	velocity = direction * move_speed
	
	if setState() == true || setDirectio() == true:
		updateAnimation()
	
	pass
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	
	
func setDirectio() -> bool:
	var new_dir : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	
	if direction.y == 0:
		new_dir = Vector2.RIGHT if direction.x < 0 else Vector2.LEFT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else  Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	sprite_2d .scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	return true
	
	
func setState() -> bool:
	var new_state : String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	state = new_state
	return true
	
	
func updateAnimation() -> void:
	animation_player.play(state + "_" + animDirection())
	pass


func animDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

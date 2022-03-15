extends KinematicBody2D

onready var state_machine = $AnimationTree.get("parameters/playback")

export var run_speed = 200
export var jump_force = 600
export var gravity = 50
export var friction = 50
export var air_resistance = 25
export var terminal_v = 800
export var knockback_taken = 500 #this will be an x direction impulse
export var health = 100
var excess_x = 0 #deals with any impulses sent in the x direction
var velocity_y = 0
var velocity_x = 0
var direction
var counter = 0
export var player = ""

var jump = false

#variables for combos
var attacking = false
var in_combo = false
export var time_till_next_input = 1
var time = 0
var current_attack = 0
var previous_attack = 0

func binary(var input):
	if input < 0:
		return -1
	elif input > 0:
		return 1

func quantize(var input, var unit):
	input /= unit
	input = int(round(input))
	input *= unit
	return input

func _physics_process(delta):
	var grounded = is_on_floor()
	direction = 0
	velocity_x = 0
	get_input()
	if not excess_x == 0:
		var excess_direction = binary(excess_x)
		
		if grounded:
			excess_x = quantize(excess_x, friction) #without quantizing, a switch from air resistance to friction may result in excess_x bouncing around 0
			excess_x -= friction * excess_direction
		else:
			excess_x = quantize(excess_x, air_resistance)
			excess_x -= air_resistance * excess_direction
	velocity_x = (direction * run_speed) + excess_x
	
		
	#if in attack, can't move
	if attacking:
		if grounded:
			jump = false

	move_and_slide(Vector2(velocity_x, velocity_y), Vector2(0, -1))
		
	#gravity and jumping	
	velocity_y += gravity
	if grounded and jump:
		velocity_y = -jump_force
	if grounded and velocity_y >= 5:
		velocity_y = 5
	if velocity_y > terminal_v:
		velocity_y = terminal_v
	
	jump = false

func get_input():
	var current = state_machine.get_current_node()
	
	
	#attacks
	if not current.begins_with("attack"):
		attacking = false
		if Input.is_action_just_pressed(player + "light_attack"):
			incr_combo()
			state_machine.travel("attack_1")
		if Input.is_action_just_pressed(player + "heavy_attack"):
			incr_combo()
			state_machine.travel("attack_2")
	else:
		attacking = true
	
	#left and right and jump movement
	if Input.is_action_pressed(player + "move_left"):
		direction = -1
	if Input.is_action_pressed(player + "move_right"):
		direction = 1
	if Input.is_action_just_pressed(player + "jump"):
		jump = true
	direction_in_x(direction)
	

func direction_in_x(direction):
	if not direction == 0:
		$Sprite.scale.x = direction
		$Hurtbox.scale.x = direction
		$AttackArea.scale.x = direction

#handles combos
func incr_combo():	
	velocity_x = 0
	attacking = true
	in_combo = true
	current_attack += 1
	time = time_till_next_input

#handles knockback and damage
func gotHurt(var hurtDirection):
	excess_x = knockback_taken * hurtDirection
	$AnimationPlayer.play("flash")
	health -= 10
	print(knockback_taken)

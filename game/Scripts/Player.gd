extends KinematicBody2D

onready var state_machine = $AnimationTree.get("parameters/playback")

export var run_speed = 200
export var jump_force = 800
export var gravity = 50
export var terminal_v = 800
var velocity_y = 0
var motion
var direction

var jump = false

#variables for combos
var in_combo = false
export var time_till_next_input = 1
var time = 0
var current_attack = 0
var previous_attack = 0

func _ready():
	pass

func get_input():
	var current = state_machine.get_current_node()
	direction = 0
	motion = 0
	
	#attacks
	if not current.begins_with("attack"):
		if Input.is_action_just_pressed("light_attack"):
			incr_combo()
			if current_attack % 2 == 1:
				state_machine.travel("attack_1")
			else:
				state_machine.travel("attack_2")
		if Input.is_action_just_pressed("heavy_attack"):
			incr_combo()
			state_machine.travel("attack_2")
	
	#left and right and jump movement
	if Input.is_action_pressed("move_left"):
		direction = -1
	if Input.is_action_pressed("move_right"):
		direction = 1
	if Input.is_action_just_pressed("jump"):
		jump = true
	direction_in_x(direction)
	motion = direction * run_speed

func _process(delta):
		#if attacking, dont do other animations
	if (in_combo):
		time -= delta
		if (time < 0):
			time = time_till_next_input
			in_combo = false
			current_attack = 0
	else:
		if direction == 0:
			state_machine.travel("idle")
		elif abs(direction) > 0:
			state_machine.travel("run")
	
	

func _physics_process(delta):
	get_input()
		
	#if in attack, can't move
	if in_combo:
		motion = 0
		jump = false
	
	motion = move_and_slide(Vector2(motion, velocity_y), Vector2(0, -1))
	
	#gravity and jumping
	var grounded = is_on_floor()
	velocity_y += gravity
	if grounded and jump:
		velocity_y = -jump_force
	if grounded and velocity_y >= 5:
		velocity_y = 5
	if velocity_y > terminal_v:
		velocity_y = terminal_v
	
	jump = false

func direction_in_x(direction):
	if not direction == 0:
		$Sprite.scale.x = direction
		$CollisionPolygon2D.scale.x = direction
		$AttackArea.scale.x = direction

#handles combos
func incr_combo():
	in_combo = true
	current_attack += 1
	time = time_till_next_input

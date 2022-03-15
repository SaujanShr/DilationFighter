extends KinematicBody2D

onready var state_machine = $AnimationTree.get("parameters/playback")

export var run_speed = 200
export var jump_force = 800
export var gravity = 50
export var terminal_v = 800
var velocity_y = 0
var motion

var jump = false
var attacking = false

func _ready():
	pass

func get_input():
	var current = state_machine.get_current_node()
	var direction = 0
	motion = 0
	
	#attacks
	if Input.is_action_just_pressed("attack_1"):
		state_machine.travel("Attack1")
		attacking = true
	if Input.is_action_just_pressed("attack_2"):
		state_machine.travel("Attack2")
		attacking = true
	
	#left and right and jump movement
	if Input.is_action_pressed("move_left"):
		direction = -1
	if Input.is_action_pressed("move_right"):
		direction = 1
	if Input.is_action_just_pressed("jump"):
		jump = true
	direction_in_x(direction)
	motion = direction * run_speed

func _physics_process(delta):
	get_input()
	#if attacking, dont do other animations
	if attacking == false:
		if motion == 0:
			state_machine.travel("Idle")
		elif abs(motion) > 0:
			state_machine.travel("Run")
	else:
		attacking = true
		
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

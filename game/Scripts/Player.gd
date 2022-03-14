extends KinematicBody2D

onready var state_machine = $AnimationTree.get("parameters/playback")
var run_speed = 100
var velocity = Vector2.ZERO

func _ready():
	pass

func get_input():
	var current = state_machine.get_current_node()
	velocity = Vector2.ZERO
	
	#attacks
	if Input.is_action_just_pressed("attack_1"):
		state_machine.travel("Attack1")
		return
	if Input.is_action_just_pressed("attack_2"):
		state_machine.travel("Attack2")
		return
	
	#left and right movement
	if Input.is_action_pressed("move_left"):
		move_in_x(-1)
	if Input.is_action_pressed("move_right"):
		move_in_x(1)
	velocity = velocity.normalized() * run_speed
	
	#if moving, run (only run, no jumps or anything or recovery time etc)
	if velocity.length() == 0:
		state_machine.travel("Idle")
	elif velocity.length() > 0:
		state_machine.travel("Run")

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func move_in_x(direction_vector):
	velocity.x = direction_vector
	$Sprite.scale.x = direction_vector
	$CollisionPolygon2D.scale.x = direction_vector
	$AttackArea.scale.x = direction_vector

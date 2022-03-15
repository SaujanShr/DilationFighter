extends "Actor.gd"
func _ready():
	pass


func _process(delta):
		#if attacking, dont do other animations
	if (in_combo):
		time -= delta
		if (time < 0):
			time = time_till_next_input
			in_combo = false
			current_attack = 0
	if (!attacking):
		if direction == 0:
			state_machine.travel("idle")
		elif abs(direction) > 0:
			state_machine.travel("run")
#on hit
func _on_AttackArea_area_entered(area):
	if not area.get_parent() == self: #checks it hasn't entered itself
		print("hurt: " + area.get_parent().name)


#on hurt
func _on_Hurtbox_area_entered(area):
	if not area.get_parent() == self: #checks it hasn't entered itself
		print("hit by: " + area.get_parent().name)
		gotHurt(area.scale.x)

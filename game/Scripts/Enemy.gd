extends "Actor.gd"
func _ready():
	pass

func _process(delta):
	var grounded = is_on_floor()
	if health <= 0:
		queue_free()
		#if attacking, dont do other animations
	if (in_combo):
		time -= delta
		if (time < 0):
			time = time_till_next_input
			in_combo = false
			current_attack = 0
	if (!attacking):
		if grounded:
			if direction == 0:
				state_machine.travel("idle")
			elif abs(direction) > 0:
				state_machine.travel("run")
		else:
			state_machine.travel("jump")
	
	

#on hit
func _on_AttackArea_area_entered(area):
	if not area.get_parent() == self: #checks it hasn't entered itself
		#print("hurt: " + area.get_parent().name)
		pass


#on hurt
func _on_Hurtbox_area_entered(area):
	if not area.get_parent() == self: #checks it hasn't entered itself
		#print("hit by: " + area.get_parent().name)
		var y_mag
		var x_mag = area.scale.x
		if area.get_parent().get("state_machine").get_current_node() == "attack_1":
			y_mag = -1
		else:
			y_mag = 0		
		var resultantMag = Vector2(x_mag, y_mag)
		gotHurt(resultantMag)


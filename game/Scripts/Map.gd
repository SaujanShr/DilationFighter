extends Node2D

func _ready():
	pass

func parralax(direction):
	var counter = 0
	for sprite in get_node("Sprites").get_children():
		counter += 1
		sprite.position.x = sprite.position.x + direction / counter

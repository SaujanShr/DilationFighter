extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	var state_machine = $musicTree.get("parameters/playback")
	state_machine.travel("selectStart")
	$StartDelay.start()
	


func _on_Options_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	pass # Replace with function body.


func _on_StartDelay_timeout():
	get_tree().change_scene("res://game/Main Scene.tscn")

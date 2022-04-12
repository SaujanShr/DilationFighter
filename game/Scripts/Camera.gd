extends Camera2D

onready var p1 = get_tree().get_nodes_in_group("p1")[0]
onready var p2 = get_tree().get_nodes_in_group("p2")[0]
export var initial_distance = 350
var initial_zoom = self.zoom

const ZOOM_LIMIT = [0.5, 1]
const CAMERA_SPEED = 3

func _ready():
	initial_zoom()
	initial_position()

func _process(_delta):
	if is_instance_valid(p1) and is_instance_valid(p2):
		zoom_function()
		position_function()

func initial_zoom():
	var distance = p1.get_position().distance_to(p2.get_position())
	var distance_factor = distance/initial_distance
	#does not zoom past the min and max values
	if distance_factor < ZOOM_LIMIT[0]:
		distance_factor = ZOOM_LIMIT[0]
	if distance_factor > ZOOM_LIMIT[1]:
		distance_factor = ZOOM_LIMIT[1]
		
	
	#zooms in if close, zooms out if far away
	zoom = (initial_zoom * distance_factor)

func initial_position():
	var p1_position = p1.get_position()
	var p2_position = p2.get_position()
	var map = get_parent().get_node("Map 1")
	#center of camera is between the two characters, plus some y elevation
	var median_position = (p1_position + p2_position) / 2
	var position_change_x = position.x - median_position.x
	position = median_position
	map.parralax(-1 * position_change_x)

#sets position of zoom
func zoom_function():
	var distance = p1.get_position().distance_to(p2.get_position())
	var distance_factor = distance/initial_distance
	#does not zoom past the min and max values
	if distance_factor < ZOOM_LIMIT[0] or distance_factor > ZOOM_LIMIT[1]:
		return
	
	#zooms in if close, zooms out if far away
	zoom = (initial_zoom * distance_factor)

#sets position of the camera
func position_function():
	var p1_position = p1.get_position()
	var p2_position = p2.get_position()
	var map = get_parent().get_node("Map 1")
	
	#center of camera is between the two characters, plus some y elevation
	var median_position = (p1_position + p2_position) / 2
	#position changes incrementally, so it looks smoother
	if position.x < median_position.x:
		position.x += CAMERA_SPEED
		map.parralax(CAMERA_SPEED)
	if position.x > median_position.x:
		position.x -= CAMERA_SPEED
		map.parralax(-1 * CAMERA_SPEED)
	if position.y < median_position.y:
		position.y += CAMERA_SPEED
	if position.y > median_position.y:
		position.y -= CAMERA_SPEED

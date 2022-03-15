extends Camera2D

onready var p1 = get_tree().get_nodes_in_group("p1")[0]
onready var p2 = get_tree().get_nodes_in_group("p2")[0]
var initial_distance = 350
var initial_zoom = self.zoom

const ZOOM_MAX = 1
const ZOOM_MIN = 0.5
const ZOOM_SPEED = 1.5

func _ready():
	pass

func _process(_delta):
	zoom_function()
	position_function()

#sets position of zoom
func zoom_function():
	var distance = abs(p1.get_position().x - p2.get_position().x)
	var distance_factor = distance/initial_distance
	if distance_factor < ZOOM_MIN or distance_factor > ZOOM_MAX:
		return
	
	zoom = (initial_zoom * distance_factor)

#sets position of the camera
func position_function():
	var offset_y = -30
	var p1_position = p1.get_position()
	var p2_position = p2.get_position()
	var map = get_parent().get_node("Map 1")
	
	var median_position = Vector2((p1_position.x + p2_position.x) / 2, offset_y + max(p1_position.y, p2_position.y))
	if position.x < median_position.x:
		position.x += ZOOM_SPEED
		map.parralax(ZOOM_SPEED)
	if position.x > median_position.x:
		position.x -= ZOOM_SPEED
		map.parralax(-1 * ZOOM_SPEED)
	if position.y < median_position.y:
		position.y += ZOOM_SPEED
	if position.y > median_position.y:
		position.y -= ZOOM_SPEED
	
	

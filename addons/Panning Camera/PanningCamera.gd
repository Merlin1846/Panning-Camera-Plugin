extends Camera2D
class_name PanningCamera
## A simple panning camera script originally intended for top down rts style 
## cameras. 
##
## Supports mouse panning as well as keyboard input and configurable 
## sensitivity/limits. To setup for your project simply set the inputs and configure
## the other values to your liking.
##
## Note:
##  [member Camera2D.anchor_mode] will always be set to [enum Camera2D.AnchorMode] [b]ANCHOR_MODE_DRAG_CENTER[/b]

# If this code looks bad, that's because it is. It's been ported between who 
# knows how many Godot versions with minor bug fixes and changes being done every
# now and then.

## The speed at which the camera pans when using the mouse.
@export_range(0.0, 10.0, 0.25, "or_greater") var sensitivity:float = 1.0
## The speed at which the camera zooms in and out.
@export_range(0.0, 10.0, 0.25, "or_greater") var zoom_sensititvity:float = 0.5
## The smallest the camera window can get.
@export var min_zoom: Vector2 = Vector2(0.25,0.25)
## The largest the camera window can get.
@export var max_zoom: Vector2 = Vector2(5,5)
## The speed at which the screen pans with the keyboard.
@export_range(0.0, 100.0, 1.0, "or_greater") var pan_speed: float = 10.0
## The multiplier used when the accelerator key is presssed. Does not effect mouse input! A value of 1.0 is equivilent to 2x and 2.0 3x
@export_range(0.0, 100.0, 1.0, "or_greater") var accelerator: float = 1.0
## If true then the camera will pan when the mouse is at the edge of the screen.
@export var screen_edge_panning: bool = true
## The width of each edge pan area on the edge of the screen.
@export_range(0.0, 100.0, 1.0, "or_greater") var edge_pan_margin: float = 16.0
# The actions used for the various things.
@export_group("Inputs")
@export var pan_up: String = "ui_up"
@export var pan_down: String = "ui_down"
@export var pan_left: String = "ui_left"
@export var pan_right: String = "ui_right"
@export var zoom_in: String = "scroll_up"
@export var zoom_Out: String = "scroll_down"
@export var mouse_pan: String = "middle_mouse_button"
@export var accelerated_panning: String = "accelerated_panning"
@export_group("", "")

func _ready():
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER

func _physics_process(delta):
	# Key board controls.
	position += (Input.get_vector(pan_left, pan_right, pan_up, pan_down)*pan_speed*(Input.get_action_strength("accelerated_panning")*accelerator+1.0))/zoom
	
	# Screen edge panning
	if screen_edge_panning && !Input.is_action_pressed(mouse_pan):
		if get_local_mouse_position().x >= ((get_window().get_size().x-(get_window().get_size().x/2))-edge_pan_margin)/zoom.x:
			position.x += pan_speed/zoom.x
		elif get_local_mouse_position().x <= (edge_pan_margin-(get_window().get_size().x/2))/zoom.x:
			position.x -= pan_speed/zoom.x
		if get_local_mouse_position().y >= ((get_window().get_size().y-(get_window().get_size().y/2))-edge_pan_margin)/zoom.y:
			position.y += pan_speed/zoom.x
		elif get_local_mouse_position().y <= (edge_pan_margin-(get_window().get_size().y/2))/zoom.y:
			position.y -= pan_speed/zoom.x

func _unhandled_input(event):
	# Mouse panning
	if event is InputEventMouseMotion:
		if Input.is_action_pressed(mouse_pan):
			global_position -= (event.relative/zoom)*sensitivity
	# Zoom
	elif event.is_action(zoom_in) and zoom < max_zoom:
		zoom += Vector2(0.01, 0.01)*zoom_sensititvity*zoom
	elif event.is_action(zoom_Out) and zoom > min_zoom:
		zoom -= Vector2(0.01, 0.01)*zoom_sensititvity*zoom

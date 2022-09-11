extends Control

var DEADZONE = 0.1
var MARGIN_FACTOR = 0.5
var start_point = Vector2(1.0, 0.0)
onready var texture = $JoystickOuter
onready var thumbstick = $JoystickInner

onready var max_width = texture.rect_size.x
onready var max_height = texture.rect_size.y

onready var half_thumbstick = thumbstick.rect_size.x / 2
onready var middle = Vector2(max_width/2, max_height/2)


func _ready():
	pass

func _on_JoystickTexture_gui_input(event):	
	# only process touch events
	
	# position the joy stick back in the middle if no press is detected
	if event is InputEventScreenTouch and not event.pressed:
		set_thumbstick_position(Vector2(middle.x, middle.y))
		Input.action_release("ui_up")
		Input.action_release("ui_right")
		Input.action_release("ui_down")
		Input.action_release("ui_left")
		
	# if we detect a touch event
	elif event is InputEventScreenTouch:
		
		# position where the touch occured (minus offset to get in the middle of the cursor
		var touch_position = Vector2(event.position.x - middle.x, event.position.y - middle.y)
		if (event.position.x > 0 and event.position.x < max_width) and (event.position.y > 0 and event.position.y < max_height):
			var angleRad = touch_position.angle_to(start_point)
			set_thumbstick_position(event.position)
			walk(angleRad)
					
	elif event is InputEventScreenDrag:
		var touch_position = Vector2(event.position.x - middle.x, event.position.y - middle.y)
		var angleRad = touch_position.angle_to(start_point)
		walk(angleRad)
		
		# check if length is greater than circle radius (a.k.a "outside") minus a margin (so the thumbstick does not go too far outside
		if(touch_position.length() > middle.x * MARGIN_FACTOR):
			var clamped = touch_position.limit_length(middle.x * MARGIN_FACTOR)
			set_thumbstick_position(Vector2(clamped.x + middle.x, clamped.y + middle.y))
		# drag is inside
		else:
			set_thumbstick_position(event.position)

func set_thumbstick_position(pos):
	thumbstick.set_position(Vector2(pos.x - half_thumbstick, pos.y - half_thumbstick))

# decides the walking direction based on four sections of the joystick (shaped like an X)
func walk(angle):
	if(angle < PI / 4 and angle > - PI /4):
		Input.action_press("ui_right")
		
		Input.action_release("ui_up")
		Input.action_release("ui_down")
		Input.action_release("ui_left")
	if(angle > PI / 4 and angle < 3 * PI / 4):
		Input.action_press("ui_up")

		Input.action_release("ui_right")
		Input.action_release("ui_down")
		Input.action_release("ui_left")
	if(angle > 3 * PI / 4 or angle < - 3 * PI /4):
		Input.action_press("ui_left")
		
		Input.action_release("ui_up")
		Input.action_release("ui_right")
		Input.action_release("ui_down")

	if(angle < - PI / 4 and angle > -3 * PI / 4):
		Input.action_press("ui_down")
		
		Input.action_release("ui_up")
		Input.action_release("ui_right")
		Input.action_release("ui_left")

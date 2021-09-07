extends Control

var DEADZONE = 0.1
onready var texture = $JoystickBackground
onready var thumbstick = $JoystickThumbstick

onready var max_width = texture.rect_size.x
onready var max_height = texture.rect_size.y

onready var half_thumbstick = thumbstick.rect_size.x / 2

func _ready():
	pass

func _on_JoystickTexture_gui_input(event):	
	# only process touch events
	
	if event is InputEventScreenTouch and not event.pressed:
		thumbstick.set_position(Vector2((max_width / 2) - half_thumbstick, (max_height / 2) - half_thumbstick))
		Input.action_release("ui_up")
		Input.action_release("ui_right")
		Input.action_release("ui_down")
		Input.action_release("ui_left")
			
	elif event is InputEventScreenTouch or event is InputEventScreenDrag:
		# only process events inside the thumbstick
		if (event.position.x > 0 and event.position.x < max_width) and (event.position.y > 0 and event.position.y < max_height):
			var new_thumbstick_position = Vector2(event.position.x - half_thumbstick, event.position.y - half_thumbstick)
			thumbstick.set_position(new_thumbstick_position)
			
			# calculate normalized positions
			
			var normalized_position = Vector2((event.position.x / max_width) - 0.5, (event.position.y / max_height) - 0.5)
			#print(normalized_position)
			
			# maybe check the deadzone before anything else...?
			# if (normalized_position.x < -DEADZONE or normalized_position.x > DEADZONE) and (normalized_position.y < -DEADZONE or normalized_position.y > DEADZONE):
			
			# move left
			if ((normalized_position.x < -DEADZONE) and (abs(normalized_position.x)  > abs(normalized_position.y))):
				Input.action_press("ui_left")
				
			# move right
			elif ((normalized_position.x > DEADZONE) and (abs(normalized_position.x) > abs(normalized_position.y))):
				Input.action_press("ui_right")
			
			# move up, only when outside of the deadzone and y bigger as x
			elif ((normalized_position.y < -DEADZONE) and (abs(normalized_position.y) > abs(normalized_position.x))):
				Input.action_press("ui_up")
			
			elif ((normalized_position.y > DEADZONE) and (abs(normalized_position.y) > abs(normalized_position.x))):
				Input.action_press("ui_down")
				
			# free all movement actions if no input
			else: 
				Input.action_release("ui_up")
				Input.action_release("ui_right")
				Input.action_release("ui_down")
				Input.action_release("ui_left")

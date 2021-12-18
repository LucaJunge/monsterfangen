extends ToolButton

signal action_pressed_event

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


func _on_action_button_up():
	#print("action pressed")
	emit_signal("action_pressed_event")

func _on_up_pressed():
	print("up pressed")


func _on_down_button_up():
	print("down pressed")

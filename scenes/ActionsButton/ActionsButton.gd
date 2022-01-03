extends Control

signal action_pressed_event

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_up_pressed():
	print("up pressed")

func _on_down_pressed():
	print("down pressed")

func _on_action_pressed():
	print("action pressed")
	emit_signal("action_pressed_event")

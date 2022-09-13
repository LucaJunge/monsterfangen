extends Control

signal exit_button_pressed

func _on_ExitButton_pressed():
	print("exit_button_pressed")
	emit_signal("exit_button_pressed")
	pass # Replace with function body.

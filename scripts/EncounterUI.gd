extends Control

signal has_attacked_signal

func _on_MainButton_button_up():
	# emit the signal to notify the parent Encounter scene
	emit_signal("has_attacked_signal")

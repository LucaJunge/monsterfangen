extends Control

signal menu_button_pressed


func _on_TextureButton_button_up():
	emit_signal("menu_button_pressed")

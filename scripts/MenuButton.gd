extends Control

# The cog symbol in the scene manager in the bottom right

signal menu_button_pressed

func _on_TextureButton_button_up():
	emit_signal("menu_button_pressed")

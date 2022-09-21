extends Control

signal exit_button_pressed
signal save_requested

func _ready() -> void:
	pass

func _on_PartyButton_button_pressed():
	print_debug("party info opens")


func _on_PlayerButton_button_pressed():
	print_debug("player info opens")


func _on_ItemsButton_button_pressed():
	print_debug("inventory opens")


func _on_ExitButton_button_pressed():
	emit_signal("exit_button_pressed")


func _on_SaveButton_button_pressed():
	# sends the save_requested signal to the OptionsMenu
	emit_signal("save_requested")
	print_debug("game saves")


func _on_LoadButton_button_pressed():
	print_debug("game loads")

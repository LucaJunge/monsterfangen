extends Node2D

onready var options_scene = "res://"
func _on_StartNewGameButton_button_up():
	print("Start New Game")
	var error_code = get_tree().change_scene("res://scenes/Intro/Intro.tscn")
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_LoadGameButton_button_up():
	# show saved games selection screen
	var error_code = get_tree().change_scene("res://scenes/SavedGames/SavedGames.tscn")
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_OptionsButton_button_up():
	# show options menu
	#get_tree().change_scene("res://scenes/Options/Options.tscn")
	var error_code = get_tree().change_scene("res://scenes/ScrollList/ScrollList.tscn")
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_Exit_button_up():
	print("Exit")
	get_tree().quit()

func _on_Licenses_button_up():
	$MainMenuCanvas/Licenses.visible = true

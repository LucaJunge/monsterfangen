extends Node2D

func _on_StartNewGameButton_pressed():
	print("Start New Game")
	#var error_code = get_tree().change_scene("res://scenes/Intro/Intro.tscn")
	#var error_code = get_tree().change_scene("res://scenes/Intro/Intro.tscn")
	var error_code = get_tree().change_scene("res://management/Game.tscn")
	if error_code != 0:
		print("ERROR: ", error_code)
		
func _on_LoadGameButton_pressed():
	# show saved games selection screen
	var error_code = get_tree().change_scene("res://scenes/SavedGames/SavedGames.tscn")
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_OptionsButton_pressed():
		# show options menu
	#get_tree().change_scene("res://scenes/Options/Options.tscn")
	var error_code = get_tree().change_scene("res://scenes/ScrollList/ScrollList.tscn")
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_Exit_pressed():
	get_tree().quit()

func _on_Licenses_pressed():
		$MainMenuCanvas/Licenses.visible = true

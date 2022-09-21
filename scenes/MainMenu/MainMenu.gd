extends Node2D

func _ready() -> void:
	# how to play music via the AudioManager
	var music = load("res://assets/music/juhani_junkala_chiptune_adventures_stage_select.mp3")
	AudioManager.play(music)

func _on_StartNewGameButton_pressed():
	SceneTransition.change_scene("res://management/Game.tscn", "horizontal_bars")

func _on_LoadGameButton_pressed():
	# show saved games selection screen
	var error_code = get_tree().change_scene("res://scenes/SavedGames/SavedGames.tscn")
	if error_code != 0:
		print("ERROR: ", error_code)

func _on_OptionsButton_pressed():
		# show options menu
	#get_tree().change_scene("res://scenes/Options/Options.tscn")
	#var error_code = get_tree().change_scene("res://scenes/ScrollList/ScrollList.tscn")
	#if error_code != 0:
	#	print("ERROR: ", error_code)
	pass

func _on_Exit_pressed():
	get_tree().quit()

func _on_Licenses_pressed():
	$MainMenuCanvas/Licenses.visible = true

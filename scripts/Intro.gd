extends Node2D

func _on_StartGameButton_button_up():
	
	# get the player name
	var playerName = $CanvasLayer/Control/Panel/MarginContainer/CenterContainer/VBoxContainer/LineEdit.get_text()

	# save in global PlayerData
	PlayerData.playerName = playerName
	
	# create a "unique" savegame name
	var date = OS.get_datetime()
	var savegame_filename: String = str(playerName) + str(date.year) + str(date.month) + str(date.day) + str(date.hour) + str(date.minute) + str(date.second) + ".save"
	
	Rules.savegame_filename = savegame_filename
	
	# change the scene to the SceneManager
	get_tree().change_scene("res://scenes/SceneManager.tscn")

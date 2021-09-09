extends Node2D

func _on_StartGameButton_button_up():
	
	# get the player name
	var playerName = $CanvasLayer/Control/Panel/MarginContainer/CenterContainer/VBoxContainer/LineEdit.get_text()

	# save in global PlayerData (TODO: rename to SavegameData)
	PlayerData.playerName = playerName
	
	# create a "unique" savegame name
	var date = OS.get_datetime()
	var savegame_filename: String = str(playerName) + str(date.year) + str(date.month) + str(date.day) + str(date.hour) + str(date.minute) + str(date.second) + ".save"
	
	PlayerData.savegame_filename = savegame_filename
	PlayerData.savegame_timestamp_created = OS.get_system_time_secs()
	
	# change the scene to the SceneManager
	get_tree().change_scene("res://scenes/SceneManager.tscn")

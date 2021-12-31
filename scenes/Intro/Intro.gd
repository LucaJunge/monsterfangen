extends Node2D
onready var line_edit = $CanvasLayer/Control/Panel/MarginContainer/CenterContainer/VBoxContainer/LineEdit
func _ready():
	line_edit.connect("text_entered", self, "start_game")
	
func _on_StartGameButton_button_up():
	# get the player name
	var playerName: String = line_edit.get_text()
	start_game(playerName)


func start_game(player_name: String):
	
	var is_valid = validate_input(player_name)
	
	if(not is_valid):
		print("Not valid")
		return

	# save in global PlayerData (TODO: rename to SavegameData)
	PlayerData.playerName = player_name
	
	# create a "unique" savegame name
	var date = OS.get_datetime()
	var savegame_filename: String = str(player_name) + str(date.year) + str(date.month) + str(date.day) + str(date.hour) + str(date.minute) + str(date.second) + ".save"
	
	PlayerData.savegame_filename = savegame_filename
	PlayerData.savegame_timestamp_created = OS.get_system_time_secs()
	
	# change the scene to the SceneManager
	get_tree().change_scene("res://scenes/SceneManager/SceneManager.tscn")

func validate_input(input: String):
	var regex = RegEx.new()
	var expression = "[A-Za-zöäüÖÄÜß]+"
	regex.compile(expression)
	
	var result = regex.search(input)
	
	if result:
		if result.get_string() == input:
			print(result.get_string() + " = " + input)
			return true

	return false

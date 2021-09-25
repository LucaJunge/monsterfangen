extends Node

var is_debug = true

func get_savegame_info(path):
	var savegame = File.new()
	var savegame_info = {}
	
	savegame.open(str(path), File.READ)
	
	while savegame.get_position() < savegame.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(savegame.get_line())
		if(node_data["filename"] == "PlayerData"):
			savegame_info["lastsaved"] = OS.get_datetime_from_unix_time(node_data["savegame_timestamp_lastsaved"])
			savegame_info["playerName"] = str(node_data["playerName"])
			# more info...

	return savegame_info

func debug_var(variable_name, variable_value):
	if is_debug:
		print(str(variable_name) + ": " + str(variable_value))

extends Node

var playerName: String = "PLAYERDATA_NAME_EMPTY"
var playerParty: Array = []

func save():
	var save_dict = {
		"filename": get_name(),
		"playerName": playerName,
		"playerParty": playerParty
	}
	
	return save_dict

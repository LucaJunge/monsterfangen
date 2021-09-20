extends Node

# Player Data
var playerName: String = "PLAYERDATA_NAME_EMPTY"
var playerPosition: Vector2 = Vector2(0, 0)
var playerDirection: Vector2 = Vector2(0, 1)
var playerParty: Array = []

# Savegame Data
var savegame_filename = "" # empty signals the SceneManager that no game shall be loaded
var savegame_timestamp_created = ""
var savegame_timestamp_lastsaved = ""

func save():
	
	var monster_index = 0
	var monster_dict = {}
	
	for monster in playerParty:
		print("saving " + str(monster.monster_name) + " at index " + str(monster_index))
		monster_dict[monster_index] = monster.save()
		monster_index += 1
	
	var save_dict = {
		"filename": get_name(),
		"playerName": playerName,
		"playerPosition": playerPosition,
		"playerParty": monster_dict,
		"savegame_timestamp_created": savegame_timestamp_created,
		"savegame_timestamp_lastsaved": OS.get_system_time_secs()
	}
	
	return save_dict

extends Node

var playerName: String = "PLAYERDATA_NAME_EMPTY"
var playerPosition: Vector2 = Vector2(0, 0)
var playerParty: Array = []

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
		"playerParty": monster_dict
	}
	
	return save_dict

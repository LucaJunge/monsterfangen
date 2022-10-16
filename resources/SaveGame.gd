class_name SaveGame
extends Reference

const SAVE_GAME_PATH := "user://save.json"

var version := 1

var stats: Resource = Stats.new()
var inventory: Resource = Inventory.new()
var party: Resource = Party.new()

var map_name := ""
var global_position := Vector2.ZERO

var _file := File.new()

func save_exists() -> bool:
	return _file.file_exists(SAVE_GAME_PATH)
	
func write_savegame() -> void:
	var error := _file.open(SAVE_GAME_PATH, File.WRITE)
	
	if error != OK:
		printerr("Could not open the file %s. Aborting save operation. Error code: %s" % [SAVE_GAME_PATH, error])
		return
	
	var data := {
		"global_position": {
			"x": global_position.x,
			"y": global_position.y
		},
		"inventory": inventory.items,
		"map_name": map_name,
		"party": iterate_party(party.members),
		"player": {
			"player_name": stats.player_name,
			"money": stats.money
		}
	}
	
	var json_string := JSON.print(data)
	_file.store_string(json_string)
	_file.close()

# Helper method to get all monster from the players party into a dictionary
func iterate_party(_party) -> Dictionary:
	var all_monsters_dict := {}
	var index = 0
	for monster in _party:
		var current = inst2dict(monster)
		all_monsters_dict[index] = current
		index += 1
	
	#print_debug(all_monsters_dict)
	return all_monsters_dict

func load_savegame() -> void:
	var error := _file.open(SAVE_GAME_PATH, File.READ)
	
	if error != OK:
		printerr("Could not open the file %s. Aborting load operation. Error code: %s" % [SAVE_GAME_PATH, error])
		return
	
	var content := _file.get_as_text()
	_file.close()
	
	var data: Dictionary = JSON.parse(content).result
	
	global_position = Vector2(data.global_position.x, data.global_position.y)
	map_name = data.map_name
	
	stats = Stats.new()
	stats.player_name = data.player.player_name
	stats.money = data.player.money
	# etc...
	# ...
	
	
	# for all party monsters...
	party = Party.new()
	
	for index in data.party:
		var monster = Monster.new(data.party[index].unique_id, data.party[index])
		party.add_member(index, monster)
	
	inventory = Inventory.new()
	inventory.items = data.inventory

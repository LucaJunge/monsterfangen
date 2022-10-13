extends Node2D
# Game.gd

var _save := SaveGame.new()

onready var _player := $SceneManager/CurrentScene/World/Player
onready var _ui := $UILayer/UI

func _ready() -> void:
	# connect signals to ui
	
	_ui.connect("reload_requested", self, "_create_or_load_save")
	_ui.connect("save_requested", self, "_save_game")
	_ui.connect("update_requested", self, "update_ui")
	
	# And the start of the game or when pressing the load button, we call this
	# function. It loads the save data if it exists, otherwise, it creates a 
	# new save file.
	_create_or_load_save()
	var game_theme = load("res://assets/music/edwinnington_a_theme.mp3")
	var _theme_player = AudioManager.play_loop(game_theme)
	

func _create_or_load_save() -> void:
	if _save.save_exists():
		_save.load_savegame()
	else:
		# add starting items
		_save.inventory.add_item("potion", 1)
		_save.inventory.add_item("monsterball", 5)
		
		var monster: Monster = Monster.new("treey", {}, 10)
		_save.party.add_member("0", monster)
		
		_save.map_name = "map_1"
		_save.global_position = _player.global_position
		
		_save.write_savegame()
		
	# After creating or loading a save resource, we need to dispatch its data
	# to the various nodes that need it.
	_player.global_position = _save.global_position
	_player.party = _save.party
	#_player.stats = _save.character
	#_ui_inventory.inventory = _save.inventory
	
func _save_game() -> void:
	print("saves game")
	_save.global_position = _player.global_position
	_save.write_savegame()

func update_ui():
	var info: Dictionary = {
		"party_members": _player.party.members
	}
	
	_ui.update_ui(info)

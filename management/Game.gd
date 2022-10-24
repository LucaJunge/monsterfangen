extends Node2D
# Game.gd - Main Entrypoint for the game

var _save := SaveGame.new()
var _player : Node2D = null
var starting_world : String = "res://scenes/World/World.tscn"

onready var _scene_manager := get_node("%SceneManager")
onready var _ui := $UILayer/UI

func _ready() -> void:
	# connect signals to ui
	
	_ui.connect("reload_requested", self, "_create_or_load_save")
	_ui.connect("save_requested", self, "_save_game")
	_ui.connect("update_requested", self, "update_ui")
	
	# At the start of the game or when pressing the load button, we call this
	# function. It loads the save data if it exists, otherwise, it creates a 
	# new save file.
	_create_or_load_save()
	var game_theme = load("res://assets/music/edwinnington_a_theme.mp3")
	var _theme_player = AudioManager.play_loop(game_theme)
	

func _create_or_load_save() -> void:
	if _save.save_exists():
		_save.load_savegame()
		change_scene(_save.map_name)
		var map = get_node("%SceneManager/CurrentScene").get_child(0)
		_player = map.get_node("Player")
	else:
		# First define the starting world, load it and get the player within
		_save.map_name = starting_world
		change_scene(_save.map_name)
		_player = get_node("%SceneManager/CurrentScene/World/Player")
		
		# Inventory -> Starting Items
		_save.inventory.add_item("potion", 1)
		_save.inventory.add_item("monsterball", 5)
		
		# Party -> Starting Monsters
		var treey: Monster = Monster.new("treey", {}, 10)
		_save.party.add_member("0", treey)
		
		var sparkpaw: Monster = Monster.new("sparkpaw", {}, 8)
		_save.party.add_member("0", sparkpaw)
		
		# Some more debug monsters if needed
		#debug_monsters(_save)
		
		# Other Properties
		_save.global_position = _player.global_position
		
		# Write the initial savegame
		_save.write_savegame()


		
	# After creating or loading a save resource, we need to dispatch its data
	# to the various nodes that need it.
	_player.global_position = _save.global_position
	_player.party = _save.party
	_player.stats = _save.stats
	
	#_ui_inventory.inventory = _save.inventory
	
func _save_game() -> void:
	print("saves game")
	var map = get_node("%SceneManager/CurrentScene").get_child(0)
	
	_player = map.get_node("Player")
	_save.global_position = _player.global_position
	_save.map_name = map.filename
	_save.write_savegame()

func update_ui():
	var info: Dictionary = {
		"party_members": _player.party.members
	}
	
	_ui.update_ui(info)

func debug_monsters(_save):
	var monster1: Monster = Monster.new("acidly", {}, 7)
	_save.party.add_member("1", monster1)
	
	var monster2: Monster = Monster.new("bigpickles", {}, 5)
	_save.party.add_member("2", monster2)
	
	var monster3: Monster = Monster.new("wispclaw", {}, 3)
	_save.party.add_member("3", monster3)
	
	var monster4: Monster = Monster.new("sparkpaw", {}, 5)
	_save.party.add_member("4", monster4)
	
	var monster5: Monster = Monster.new("vaportalon", {}, 4)
	_save.party.add_member("5", monster5)

func change_scene(target: String) -> void:
	# remove the current scene
	var current_scene = get_node("SceneManager/CurrentScene")
	
	var current_world = current_scene.get_child(0)
	
	if current_world:
		current_scene.remove_child(current_world)
		#current_scene.call_deferred("free") # doesnt work with this commented in
	
	var next_world_resource = load(target)
	var next_world = next_world_resource.instance()
	current_scene.add_child(next_world)

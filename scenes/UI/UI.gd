extends Control

signal save_requested
signal reload_requested
signal update_requested

onready var _menu_button = get_node("%MenuButton")
onready var options_menu = get_node("%OptionsMenu")
onready var party_menu = get_node("%PartyMenu")
onready var player_menu = get_node("%PlayerMenu")
onready var items_menu = get_node("%ItemsMenu")
onready var click = load("res://assets/sounds/click.wav")

func _ready() -> void:
	_menu_button.connect("menu_button_pressed", self, "open_menu")
	
	# these connections come from the OptionsMenu buttons 
	options_menu.connect("save_requested", self, "emit_signal", ["save_requested"])
	options_menu.connect("close_options", self, "close_menu")
	options_menu.connect("open_party_menu", self, "open_party_menu")
	options_menu.connect("open_player_menu", self, "open_player_menu")
	options_menu.connect("open_items_menu", self, "open_items_menu")
	
func update_ui(info: Dictionary) -> void:
	print("update UI")
	# update the components of the ui
	party_menu.update_ui(info.party_members)
	player_menu.update_ui()
	# etc...

func open_menu() -> void:
	AudioManager.play(click)
	SceneTransition.change_overlay($OptionsMenu, "horizontal_bars")

func close_menu() -> void:
	SceneTransition.change_overlay($OptionsMenu, "horizontal_bars")

func open_party_menu() -> void:
	_request_update()
	SceneTransition.change_overlay(party_menu, "horizontal_bars")
	
func open_player_menu() -> void:
	_request_update()
	SceneTransition.change_overlay(player_menu, "horizontal_bars")

func open_items_menu() -> void:
	_request_update()
	SceneTransition.change_overlay(items_menu, "horizontal_bars")

func _request_update():
	emit_signal("update_requested")

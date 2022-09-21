extends Control

signal save_requested
signal reload_requested

onready var _menu_button = get_node("%MenuButton")
onready var options_menu = get_node("OptionsMenu")
onready var click = load("res://assets/sounds/click.wav")

func _ready() -> void:
	print(_menu_button)
	
	_menu_button.connect("menu_button_pressed", self, "open_menu")
	options_menu.connect("save_requested", self, "emit_signal", ["save_requested"])
	options_menu.connect("options_closed", self, "close_menu")

func open_menu() -> void:
	
	AudioManager.play(click)
	#AudioManager.play_direct("click")
	SceneTransition.change_overlay($OptionsMenu, "horizontal_bars")

func close_menu() -> void:
	SceneTransition.change_overlay($OptionsMenu, "horizontal_bars")

extends CanvasLayer

onready var select_arrow = $Control/NinePatchRect/TextureRect
onready var menu = $Control

enum ScreenLoaded { NOTHING, JUST_MENU, PARTY_SCREEN }
var screen_loaded = ScreenLoaded.NOTHING

# Called when the node enters the scene tree for the first time.
func _ready():
	menu.visible = false

func _unhandled_input(event):
	match screen_loaded:
		ScreenLoaded.NOTHING:
			if event.is_action_pressed("menu_open"):
				menu.visible = !menu.visible
			if event.is_action_pressed("menu_close"):
				menu.visible = false


# Toggles the menu in the top right corner
func _on_TextureButton_button_down():
	menu.visible = !menu.visible

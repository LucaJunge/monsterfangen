extends Panel

signal close_options
signal save_requested
signal exit_button_pressed
signal open_party_menu
signal open_player_menu
signal open_items_menu

var was_clicked: bool = false

onready var party_button = get_node("%PartyButton")
onready var player_button = get_node("%PlayerButton")
onready var items_button = get_node("%ItemsButton")
onready var exit_button = get_node("%ExitButton")
onready var save_button = get_node("%SaveButton")
onready var load_button = get_node("%LoadButton")


func _ready():
	self.visible = false


func _on_PartyButton_button_pressed():
	emit_signal("open_party_menu")


func _on_ExitButton_button_pressed():
	emit_signal("close_options")


func _on_SaveButton_button_pressed():
	emit_signal("save_requested")


func _on_PlayerButton_button_pressed() -> void:
	emit_signal("open_player_menu")
	
	
func _on_ItemsButton_button_pressed() -> void:
	emit_signal("open_items_menu")
	
	
func disable_all():
	party_button.disabled = true
	player_button.disabled = true
	items_button.disabled = true
	exit_button.disabled = true
	save_button.disabled = true
	load_button.disabled = true




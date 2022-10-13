extends Control

signal exit_button_pressed
signal save_requested
signal open_party_menu

var was_clicked: bool = false

onready var party_button = get_node("%PartyButton")
onready var player_button = get_node("%PlayerButton")
onready var items_button = get_node("%ItemsButton")
onready var exit_button = get_node("%ExitButton")
onready var save_button = get_node("%SaveButton")
onready var load_button = get_node("%LoadButton")


func _ready() -> void:
	pass

func _on_PartyButton_button_pressed():
	emit_signal("open_party_menu")
	#disable_all()

func _on_PlayerButton_button_pressed():
	print_debug("player info opens")

func _on_ItemsButton_button_pressed():
	print_debug("inventory opens")

func _on_ExitButton_button_pressed():
	emit_signal("exit_button_pressed")

func _on_SaveButton_button_pressed():
	# sends the save_requested signal to the OptionsMenu
	emit_signal("save_requested")
	print_debug("game saves")

func _on_LoadButton_button_pressed():
	print_debug("game loads")

func disable_all():
	party_button.disabled = true
	player_button.disabled = true
	items_button.disabled = true
	exit_button.disabled = true
	save_button.disabled = true
	load_button.disabled = true

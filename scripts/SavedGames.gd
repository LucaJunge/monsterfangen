extends Node2D

onready var savegame_container = $CanvasLayer/Panel/MarginContainer/ScrollContainer/VBoxContainer
onready var empty_message = $CanvasLayer/Panel/MarginContainer/ScrollContainer/VBoxContainer/empty_message

onready var savegames = []
var savegame_template = load("res://scenes/SavegameContainer.tscn")

func _ready():
	get_savegames("user://")
	create_savegame_containers()

func get_savegames(path: String):
	var directory = Directory.new()
	directory.open(path)
	
	directory.list_dir_begin(true, true)
	
	# if no savegames found, show "No savegames found."
	
	while true:
		var savegame = directory.get_next()
		
		if savegame == "":
			break
			
		elif directory.current_is_dir():
			continue
			
		else:
			savegames.append(savegame)
	
func create_savegame_containers():
	
	if savegames.empty():
		empty_message.visible = true
	
	for savegame in savegames:
		
		var current_savegame = savegame_template.instance()
		
		var savegame_title = current_savegame.get_node("MarginContainer/Container/savegame_title")
		
		savegame_title.set_text(savegame)
		current_savegame.savegame_filename = savegame
		
		# savegame_info = ...
		
		savegame_container.add_child(current_savegame)


func _on_back_to_menu_button_button_up():
	get_tree().change_scene("res://scenes/MainMenu.tscn")

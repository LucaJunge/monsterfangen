extends Control

onready var monster_panel_container = $Panel/MarginContainer/VBoxContainer/

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(6):
		print(i)

func _on_back_button_button_up():
	get_parent().get_node("MarginContainer").visible = true
	visible = false

func update_ui():
	# for each node in playerParty
	#print(PlayerData.playerParty.size()-1)
	for i in range(PlayerData.playerParty.size()):
		#print(i)

		var current_monster_panel = monster_panel_container.get_child(i)
		current_monster_panel.set_info(
			PlayerData.playerParty[i]["sprite"],
			PlayerData.playerParty[i]["monster_name"],
			PlayerData.playerParty[i]["level"],
			"M",
			PlayerData.playerParty[i]["current_health"])
		# get all info fields
		#var monster_name = current_monster_panel.get_node("HBoxContainer/InfoGrid/HBoxContainer/monster_name")
		#var monster_level = current_monster_panel.get_node("HBoxContainer/InfoGrid/HBoxContainer/HBoxContainer/monster_level")
		#var monster_gender = current_monster_panel.get_node("HBoxContainer/InfoGrid/HBoxContainer/HBoxContainer/monster_gender")
		#var monster_hp = current_monster_panel.get_node("HBoxContainer/InfoGrid/monster_hp")
		#var monster_sprite = current_monster_panel.get_node("HBoxContainer/Sprite")
		
		
		#monster_name.set_text(PlayerData.playerParty[i].monster_name)
		#monster_level.set_text(str(PlayerData.playerParty[i].level))
		#monster_hp.set_text(str(PlayerData.playerParty[i].current_health))
		#monster_sprite.set_texture(load(PlayerData.playerParty[i]["sprite"]))
		
		print("loaded " + PlayerData.playerParty[i].monster_name)

extends Control

onready var monster_panel_container = $Panel/MarginContainer/VBoxContainer/

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_back_button_button_up():
	visible = false
	get_parent().get_node("MarginContainer").visible = true

func update_ui():
	# for each node in playerParty
	#print(PlayerData.playerParty.size()-1)
	for i in range(PlayerData.playerParty.size()):
		#print(i)

		var current_monster_panel = monster_panel_container.get_child(i)
		
		var monster_name = current_monster_panel.get_node("HBoxContainer/VBoxContainer/monster_name")
		monster_name.set_text(PlayerData.playerParty[i].monster_name)
		
		var monster_hp = current_monster_panel.get_node("HBoxContainer/VBoxContainer/monster_hp")
		monster_hp.set_text("level: " + str(PlayerData.playerParty[i].level) + "\nhp: " + str(PlayerData.playerParty[i].current_health)+ "\nattack: " + str(PlayerData.playerParty[i].current_attack) + "\ndefense: " + str(PlayerData.playerParty[i].current_defense) + "\ntempo: " + str(PlayerData.playerParty[i].current_tempo))
		
		var monster_sprite = current_monster_panel.get_node("HBoxContainer/TextureRect")
		monster_sprite.set_texture(load(PlayerData.playerParty[i]["sprite"]))
		
		print("loaded " + PlayerData.playerParty[i].monster_name)

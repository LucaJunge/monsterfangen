extends Control

onready var monster_panel_container = $Panel/MarginContainer/VBoxContainer/

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
		#print("loaded " + PlayerData.playerParty[i].monster_name)

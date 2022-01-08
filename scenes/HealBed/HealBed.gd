extends StaticBody2D

export (String, FILE) var dialog_file = "res://assets/dialogs/healbed.json"

func _ready():
	pass # Replace with function body.

func interact():
	get_node("/root/SceneManager/DialogManager").start_dialog(dialog_file)
	get_node("/root/SceneManager").heal_player()

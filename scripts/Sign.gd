extends StaticBody2D

export (String, FILE) var dialog_file = "res://assets/dialogs/default.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func interact():
	# disable player movement
	# add text to box
	get_node("/root/SceneManager/DialogManager").start_dialog(dialog_file)
	pass

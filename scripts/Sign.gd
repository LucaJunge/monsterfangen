extends StaticBody2D

export (String, FILE) var dialog_file = "res://assets/dialogs/default.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func trigger_dialog():
	# show box
	# disable player movement
	# add text to box
	var dialog = get_node("/root/SceneManager/UI/Dialog")
	print("this is a dialog")
	pass

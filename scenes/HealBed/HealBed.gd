extends StaticBody2D

export (Resource) var dialog 


func _ready():
	pass # Replace with function body.

func interact():
	print("interact")
	DialogManager.show_dialog(dialog)
	#get_node("/root/SceneManager/DialogManager").start_dialog(dialog_file)
	#get_node("/root/SceneManager").heal_player()

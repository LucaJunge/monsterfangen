extends StaticBody2D

export (Resource) var dialog 

func interact():
	print("interact")
	DialogManager.show_dialog(dialog)
	# heal the player

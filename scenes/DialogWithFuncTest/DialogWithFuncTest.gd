extends StaticBody2D

export (Resource) var dialog 

func interact(player: KinematicBody2D):
	print("interact")
	DialogManager.show_dialog(dialog)
	

extends StaticBody2D

export (Resource) var dialog 

func interact(dialog: Dialog) -> void:
	DialogManager.show_dialog(dialog)

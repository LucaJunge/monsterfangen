extends Panel

var savegame_filename = ""

func _on_SavegameContainer_gui_input(event):
	if event is InputEventScreenTouch:
		if not event.pressed:
			Rules.savegame_filename = savegame_filename
			load_scene_manager()

func load_scene_manager():
	get_tree().change_scene("res://scenes/SceneManager.tscn")

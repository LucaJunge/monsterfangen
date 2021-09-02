extends Panel

var filepath_to_load = ""

func _on_SavegameContainer_gui_input(event):
	if event is InputEventScreenTouch:
		if not event.pressed:
			
			print("user://" + filepath_to_load)

func load_scene_manager(filepath):
	#get_tree().load("")
	pass

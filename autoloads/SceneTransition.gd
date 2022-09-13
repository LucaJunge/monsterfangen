extends CanvasLayer

func change_scene(target: String, type: String = "fade") -> void:
	if type == "fade":
		transition_fade(target)
	elif type == "horizontal_bars":
		transition_horizontal_bars(target)
	else:
		print_debug("SceneTransition type %s does not exist" % type)
	
func transition_fade(target: String) -> void:
	$AnimationPlayer.play("fade_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(target)
	$AnimationPlayer.play("fade_out")

func transition_horizontal_bars(target):
	$AnimationPlayer.play("horizontal_bars_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(target)
	$AnimationPlayer.play("horizontal_bars_out")


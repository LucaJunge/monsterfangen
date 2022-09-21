extends CanvasLayer

func change_scene(target: String, type: String = "fade") -> void:
	if type == "fade":
		transition_fade(target)
	elif type == "horizontal_bars":
		transition_horizontal_bars(target)
	else:
		print_debug("SceneTransition type %s does not exist" % type)

func change_overlay(overlay_to_close: Node, type: String = "fade" ) -> void:
	if type == "fade":
		overlay_fade(overlay_to_close)
	elif type == "horizontal_bars":
		overlay_horizontal_bars(overlay_to_close)
	else:
		print_debug("SceneTransition type %s does not exist" % type)

func transition_fade(target: String) -> void:
	$AnimationPlayer.play("fade_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(target)
	$AnimationPlayer.play("fade_out")

func transition_horizontal_bars(target: String):
	$AnimationPlayer.play("horizontal_bars_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene(target)
	$AnimationPlayer.play("horizontal_bars_out")
	
func overlay_fade(target: Node) -> void:
	$AnimationPlayer.play("fade_in")
	yield($AnimationPlayer, "animation_finished")
	target.visible = !target.visible
	$AnimationPlayer.play("fade_out")

func overlay_horizontal_bars(target: Node):
	$AnimationPlayer.play("horizontal_bars_in")
	yield($AnimationPlayer, "animation_finished")
	target.visible = !target.visible
	$AnimationPlayer.play("horizontal_bars_out")

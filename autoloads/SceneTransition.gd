extends CanvasLayer

func change_scene(target: String, type: String = "fade", spawn_position: Vector2 = Vector2(0, 0)) -> void:
	if type == "fade":
		_transition_fade(target, spawn_position)
	elif type == "horizontal_bars":
		_transition_horizontal_bars(target, spawn_position)
	else:
		print_debug("SceneTransition type %s does not exist" % type)

func change_overlay(overlay_to_close: Node, type: String = "fade" ) -> void:
	if type == "fade":
		_overlay_fade(overlay_to_close)
	elif type == "horizontal_bars":
		_overlay_horizontal_bars(overlay_to_close)
	elif type == "foliage":
		_overlay_foliage(overlay_to_close)
	else:
		print_debug("SceneTransition type %s does not exist" % type)

func _transition_fade(target: String, spawn_position: Vector2) -> void:
	$AnimationPlayer.play("fade_in")
	yield($AnimationPlayer, "animation_finished")
	#SceneManager.change_scene(target)
	get_node("/root/Game").change_scene(target, spawn_position)
	$AnimationPlayer.play("fade_out")

func _transition_horizontal_bars(target: String, spawn_position: Vector2):
	$AnimationPlayer.play("horizontal_bars_in")
	yield($AnimationPlayer, "animation_finished")
	#SceneManager.change_scene(target)
	get_node("/root/Game").change_scene(target, spawn_position)
	$AnimationPlayer.play("horizontal_bars_out")
	
func _overlay_fade(target: Node) -> void:
	$AnimationPlayer.play("fade_in")
	yield($AnimationPlayer, "animation_finished")
	target.visible = !target.visible
	$AnimationPlayer.play("fade_out")

func _overlay_horizontal_bars(target: Node):
	$AnimationPlayer.play("horizontal_bars_in")
	yield($AnimationPlayer, "animation_finished")
	target.visible = !target.visible
	$AnimationPlayer.play("horizontal_bars_out")

func _overlay_foliage(target: Node):
	$AnimationPlayer.play("foliage_in")
	yield($AnimationPlayer, "animation_finished")
	target.visible = !target.visible
	$AnimationPlayer.play("foliage_out")

func debug_animation(animation: String) -> void:
	$AnimationPlayer.play(animation)

# Loads the Game.tscn from MainMenu.tscn
func load_from_main_menu(target : String) -> void:
	$AnimationPlayer.play("horizontal_bars_in")
	yield($AnimationPlayer, "animation_finished")
	#SceneManager.change_scene(target)
	get_tree().change_scene(target)
	$AnimationPlayer.play("horizontal_bars_out")

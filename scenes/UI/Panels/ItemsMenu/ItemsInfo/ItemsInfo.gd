extends PanelContainer

signal clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	AudioManager.play_click()
	if $AnimationPlayer.current_animation != "":
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play("click")
	else:
		$AnimationPlayer.play("click")
	emit_signal("clicked")


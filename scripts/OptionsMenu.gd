extends Panel

signal exit_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Exit_button_up():
	#$AnimationPlayer.play("SlideIn")
	emit_signal("exit_button_pressed")

func emit_exit_signal():
	emit_signal("exit_button_pressed")

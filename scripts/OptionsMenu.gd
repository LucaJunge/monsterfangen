extends Panel

signal exit_button_pressed
signal save_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	var playerLabel = $MarginContainer/VBoxContainer/Player
	if(PlayerData.playerName):
		playerLabel.set_text(PlayerData.playerName)
	else:
		playerLabel.add_color_override("font_color", Color(1.0, 0.5, 1.0))
		playerLabel.add_color_override("font_color_hover", Color(0.8, 0.3, 0.8))


func _on_Exit_button_up():
	#$AnimationPlayer.play("SlideIn")
	emit_signal("exit_button_pressed")

func emit_exit_signal():
	emit_signal("exit_button_pressed")


func _on_Save_button_up():
	emit_signal("save_button_pressed")

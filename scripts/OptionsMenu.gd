extends Panel

signal exit_button_pressed
signal save_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	var playerLabel = $MarginContainer/VBoxContainer/Player
	playerLabel.set_text(PlayerData.playerName)

func update_ui():
	var playerLabel = $MarginContainer/VBoxContainer/Player
	playerLabel.set_text(PlayerData.playerName)

func _on_Exit_button_up():
	#$AnimationPlayer.play("SlideIn")
	emit_signal("exit_button_pressed")

func emit_exit_signal():
	emit_signal("exit_button_pressed")

func _on_Save_button_up():
	emit_signal("save_button_pressed")

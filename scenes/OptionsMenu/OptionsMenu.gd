extends Panel

signal options_closed
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_OptionsGrid_exit_button_pressed():
	emit_signal("options_closed")

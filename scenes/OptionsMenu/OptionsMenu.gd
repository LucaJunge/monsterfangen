extends Panel

signal options_closed
signal save_requested

onready var options_grid = $MarginContainer/OptionsGrid

func _ready():
	options_grid.connect("save_requested", self, "emit_signal", ["save_requested"])
	pass

func _on_OptionsGrid_exit_button_pressed():
	emit_signal("options_closed")

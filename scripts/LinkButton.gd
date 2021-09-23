extends Button

var url = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_LinkButton_button_up():
	OS.shell_open(url)

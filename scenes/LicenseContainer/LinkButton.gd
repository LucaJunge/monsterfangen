extends Button

var url = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_LinkButton_button_up():
	var error_code = OS.shell_open(url)
	if error_code != 0:
		print("ERROR: ", error_code)

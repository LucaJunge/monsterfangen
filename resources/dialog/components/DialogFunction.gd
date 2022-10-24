class_name DialogFunction
extends Resource

# This class can trigger the dialog function

# this is overriden by extended dialog_function scripts
func dialog_function() -> void:
	print_debug("hello from default dialog function")
	
	
func get_class():
	return "DialogFunction"

func is_class(value):
	if value == "DialogFunction":
		return true
	else:
		return false

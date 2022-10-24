class_name Dialog
extends Resource

# A Dialog consists of different resources, namely DialogFunction and DialogLines
# We need "Resource" here, to enable both Strings (in form of DialogLine) and Functions here
# Using native Strings and Resources doesn't seem to work
export (Array, Resource) var dialog_lines := []

func _to_string() -> String:
	var output := self.resource_path.get_file().trim_suffix('.tres') + " -> "
	var separator = ", "
	
	for index in range(0, dialog_lines.size()):
		output += str(dialog_lines[index])
		if index < dialog_lines.size() - 1:
			output += separator
			
	return output

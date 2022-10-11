class_name Dialog
extends Resource

export var name := "NULL"
export (Array, String) var dialog_lines := [""]

func _to_string() -> String:
	var output := self.resource_path.get_file().trim_suffix('.tres') + " -> "
	var separator = ", "
	
	for index in range(0, dialog_lines.size()):
		output += str(dialog_lines[index])
		if index < dialog_lines.size() - 1:
			output += separator
			
	return output

class_name DialogLine
extends Resource

export(String) var npc_name := ""
export(String) var line := ""

func get_class():
	return "DialogLine"

func is_class(value):
	if value == "DialogLine":
		return true
	else:
		return false

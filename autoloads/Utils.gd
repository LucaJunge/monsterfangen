extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_player_node():
	var scene_manager_node = get_node("/root/Game/SceneManager")
	
	var player = scene_manager_node.find_node("Player", true, false)
	
	return player


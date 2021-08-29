extends Area2D

export (String, FILE) var next_scene_path = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = find_parent("CurrentScene").get_children().back().find_node("Player")
	player.connect("player_has_entered_signal", self, "do_transition")

func do_transition():
	get_node(NodePath("/root/SceneManager")).transition_to_scene(next_scene_path)

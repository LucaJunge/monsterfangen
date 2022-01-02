extends Area2D

export (String, FILE) var next_scene_path = ""

onready var player = find_parent("CurrentScene").get_children().back().find_node("Player")


func _ready():
	player.connect("player_has_entered_signal", self, "do_transition")

func do_transition():
	PlayerData.playerPosition = position + Vector2(0, 0)
	PlayerData.playerDirection = player.input_direction
	get_node(NodePath("/root/SceneManager")).transition_to_scene(next_scene_path)

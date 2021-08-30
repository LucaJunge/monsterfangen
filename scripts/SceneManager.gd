extends Node2D

var next_scene = null
onready var save_button = $"CurrentScene/Map/MenuLayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	save_button.connect("save_game_signal", self, "save_game")


func transition_to_scene(new_scene: String):
	next_scene = new_scene
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")

func transition_to_transparent():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(load(next_scene).instance())
	$ScreenTransition/AnimationPlayer.play("FadeToTransparent")

func save_game():
	print("saving game...")
	
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	
	# get all nodes that should be persisted
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	
	for node in save_nodes:
		print(node)
		
		# Check the node is an instanced scene so it can be instanced again during load
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
			
		# Check the node has a save function
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		
		# Call the nodes save function
		var node_data = node.call("save")
		
		# Store the save dictionary as a new line in the save file
		save_game.store_line(to_json(node_data))
	save_game.close()

		
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		print("No savegame exists.")
		return # Error, No savegame to load
	
	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	
	for node in save_nodes:
		node.queue_free()
	
	# Load the save game line by line and process the dictionary to restore the objects
	save_game.open("user://savegame.save", File.READ)
	
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		
		# First, create the object, add it to the tree and set its position
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		
		# Set the remaining variables
		for key in node_data.keys():
			if key == "filename" or key == "parent" or key == "pos_x" or key == "pos_y":
				continue
			new_object.set(key, node_data[key])
			
	print("game loaded.")
	save_game.close()

extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartGameButton_button_up():
	
	# get the player name
	var playerName = $CanvasLayer/Control/Panel/MarginContainer/CenterContainer/VBoxContainer/LineEdit.get_text()
	print(playerName)

	# save in global PlayerData
	PlayerData.playerName = playerName
	
	# change the scene to the SceneManager
	get_tree().change_scene("res://scenes/SceneManager.tscn")

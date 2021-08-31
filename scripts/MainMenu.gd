extends Node2D


func _on_StartNewGameButton_button_up():
	print("Start New Game")
	pass # Replace with function body.


func _on_LoadGameButton_button_up():
	print("Load Game")
	get_tree().change_scene("res://scenes/SceneManager.tscn")
	#load("res://scenes/Map.tscn").instance()
	pass # Replace with function body.


func _on_OptionsButton_button_up():
	print("Options")
	pass # Replace with function body.


func _on_Exit_button_up():
	print("Exit")
	get_tree().quit()
	pass # Replace with function body.

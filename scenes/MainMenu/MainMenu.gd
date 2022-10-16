extends Node2D

onready var main_theme: AudioStreamPlayer
onready var licenses = get_node("%Licenses")

func _ready() -> void:
	# how to play music via the AudioManager
	var main_theme_res = load("res://assets/music/juhani_junkala_chiptune_adventures_stage_select.mp3")
	main_theme = AudioManager.play(main_theme_res, -15.0)

func _on_StartNewGameButton_pressed():
	AudioManager.fade_out(main_theme)
	SceneTransition.load_from_main_menu("res://management/Game.tscn")

func _on_LoadGameButton_pressed():
	SceneTransition.change_scene("res://scenes/SavedGames/SavedGames.tscn")

func _on_OptionsButton_pressed():
	SceneTransition.change_scene("res://scenes/Options/Options.tscn")

func _on_Exit_pressed():
	get_tree().quit()

func _on_Licenses_pressed():
	SceneTransition.change_overlay(licenses, "fade")

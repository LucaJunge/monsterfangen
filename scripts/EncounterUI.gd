extends Control

signal has_attacked_signal

onready var playerSpriteAnimationPlayer = $VSplitContainer/VBoxContainer/MarginContainer2/PlayerContainer/PlayerSprite/AnimationPlayer
onready var enemySpriteAnimationPlayer = $VSplitContainer/VBoxContainer/MarginContainer/EnemyContainer/EnemySprite/AnimationPlayer
func _ready():
	playerSpriteAnimationPlayer.play("Idle")
	enemySpriteAnimationPlayer.play("Idle")
	
# This is the current attack button
func _on_MainButton_button_up():
	# emit the signal to notify the parent Encounter scene
	emit_signal("has_attacked_signal")

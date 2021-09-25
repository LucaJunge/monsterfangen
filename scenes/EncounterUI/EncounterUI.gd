extends Control

signal has_attacked_signal
signal wants_to_flee

onready var playerSpriteAnimationPlayer = $VSplitContainer/Control/VBoxContainer/MarginContainer2/PlayerContainer/PlayerSprite/AnimationPlayer
onready var enemySpriteAnimationPlayer = $VSplitContainer/Control/VBoxContainer/MarginContainer/EnemyContainer/EnemySprite/AnimationPlayer

func _ready():
	#playerSpriteAnimationPlayer.play("Idle")
	#enemySpriteAnimationPlayer.play("Idle")
	pass
	
# This is the current attack button
func _on_FightButton_button_up():
	emit_signal("has_attacked_signal")


func _on_RunButton_button_up():
	emit_signal("wants_to_flee")

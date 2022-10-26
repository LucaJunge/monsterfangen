extends Panel

onready var click = load("res://assets/sounds/click.wav")

func _ready() -> void:
	self.visible = false

func _on_BackButton_pressed() -> void:
	AudioManager.play(click)
	SceneTransition.change_overlay(self, "fade")

func update_ui() -> void:
	pass

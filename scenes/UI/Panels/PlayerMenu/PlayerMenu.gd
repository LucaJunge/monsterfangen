extends Panel


onready var click = load("res://assets/sounds/click.wav")

func _ready():
	self.visible = false

func update_ui() -> void:
	print_debug("update ui of player menu")
	pass

func _on_BackButton_pressed():
	AudioManager.play(click)
	SceneTransition.change_overlay(self, "fade")

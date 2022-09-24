extends CanvasLayer

onready var run_sound = preload("res://assets/sounds/run.wav")
onready var main_theme = preload("res://assets/music/edwinnington_a_theme.mp3")
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RunButton_pressed() -> void:
	AudioManager.play(run_sound)
	_exit_scene()

func _exit_scene() -> void:
	SceneTransition.change_overlay(self, "fade")
	AudioManager.stop()
	AudioManager.play_loop(main_theme)

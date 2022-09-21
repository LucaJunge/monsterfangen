extends CanvasLayer

var dialog_name := ""
var current_dialog := []

onready var click = load("res://assets/sounds/interaction_continue.wav")

func _ready() -> void:
	self.visible = false

func show_dialog(_dialog: Dialog) -> void:
	var dialog = _dialog.duplicate()
	dialog_name = dialog.name
	current_dialog = dialog.dialog_lines
	advance_dialog()
	self.visible = true

func advance_dialog() -> void:
	$AnimationPlayer.play("RESET")
	var current_line = current_dialog.pop_front()
	if current_line == null:
		reset()
	else:
		get_node("%NPCName").text = dialog_name
		get_node("%CurrentLine").text = current_line
		$AnimationPlayer.play("TextProgress")
	AudioManager.play(click)

func _on_ContinueButton_pressed():
	advance_dialog()


func reset() -> void:
	dialog_name = "EMPTY"
	current_dialog = []
	self.visible = false

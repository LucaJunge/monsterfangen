extends CanvasLayer

var dialog_name := ""
var current_dialog := []

onready var click = load("res://assets/sounds/interaction_continue.wav")

func _ready() -> void:
	self.visible = false

func show_dialog(_dialog: Dialog) -> void:
	var dialog = _dialog.duplicate()
	current_dialog = dialog.dialog_lines
	advance_dialog()
	self.visible = true

func advance_dialog() -> void:
	$AnimationPlayer.play("RESET")
	var current_line = current_dialog.pop_front()
	if current_line == null:
		reset()
	else:
		# ToDo: Fix "Cant call non-static gunction get_class in script"
		if(current_line.get_class() == "DialogLine"):
			get_node("%NPCName").text = current_line.npc_name
			get_node("%CurrentLine").text = current_line.line
			$AnimationPlayer.play("TextProgress")
		#elif(current_line.get_class() == "DialogFunction"):
		#	print("function here")
		else:
			print("function here")
			var _instance = current_line.new()
			#ToDo call: Can't call non-static function 'dialog_function' in script.
			current_line.dialog_function()
			
	AudioManager.play(click)

func _on_ContinueButton_pressed():
	advance_dialog()


func reset() -> void:
	dialog_name = "EMPTY"
	current_dialog = []
	self.visible = false

extends Node2D

onready var dialog_box = get_node("/root/SceneManager/UI/Dialog")
onready var dialog_text = get_node("/root/SceneManager/UI/Dialog/MarginContainer/MarginContainer/Text")

onready var action_button = get_node("/root/SceneManager/UI/ActionsButton/HBoxContainer/action")
onready var up_button = get_node("/root/SceneManager/UI/ActionsButton/HBoxContainer/VBoxContainer/up")
onready var down_button = get_node("/root/SceneManager/UI/ActionsButton/HBoxContainer/VBoxContainer/down")

var dialog_started: bool = false
var dialog_array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	dialog_box.get_node("AnimationPlayer").connect("animation_finished", self, "on_dialog_text_finished")
	pass # Replace with function body.

func start_dialog(dialog_file: String):
	# display the next line if a dialog has been started
	if(dialog_started):
		next_line()
	else:
		# create a new file
		var file = File.new()
		file.open(dialog_file, File.READ)
		var json = JSON.parse(file.get_as_text())
		file.close()
		
		if typeof(json.result) != TYPE_ARRAY:
			push_error("Unexpected results.")
		
		dialog_array = json.result
		dialog_box.visible = true
		dialog_started = true
		
		next_line()

func next_line():
	# disable action button
	action_button.disabled = true
	
	# get the next line and remove it from the array
	var next_line = dialog_array.pop_front()
	
	# if the dialog is finished
	if next_line == null:
		action_button.disabled = false
		dialog_box.visible = false
		dialog_started = false
		# activate player movement again...
		#emit("")
		return
	
	# get new first entry and display it
	dialog_text.set_text(next_line)
	
	# play animation
	# bug: currently shorter texts are played slower than longer texts, because of the animation length
	# set the animation length via a formula e.g. total_characters / 50
	dialog_box.get_node("AnimationPlayer").play("draw_text")
	
# on animation finished -> enable action button
func on_dialog_text_finished(animation_name):
	if animation_name == "draw_text":
		# wait for 200ms to close the dialog / display the next line
		action_button.disabled = false
	

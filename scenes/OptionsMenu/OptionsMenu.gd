extends Panel

signal exit_button_pressed
signal save_button_pressed

onready var party_screen = $PartyScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_ui():

	
	# cut name if there are more than 10 characters
	#if(PlayerData.playerName.length() >= 10):
	#	playerLabel.set_text(PlayerData.playerName.substr(0, 10) + "...")
	#else:
	#playerLabel.set_text(PlayerData.playerName)
		
	# update the party screen with the current monsters
	party_screen.update_ui()

func _on_Exit_button_up():
	#$AnimationPlayer.play("SlideIn")
	emit_signal("exit_button_pressed")

func emit_exit_signal():
	emit_signal("exit_button_pressed")

func _on_Save_button_up():
	emit_signal("save_button_pressed")

func _on_PartyScreen_button_up():
	$HBoxContainer.visible = false
	party_screen.visible = true

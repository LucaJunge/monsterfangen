extends Node2D

signal timeout
onready var dialogBox = $CanvasLayer/EncounterUI/VSplitContainer/VBoxContainer2/NinePatchRect/DialogText
onready var attackButton = $CanvasLayer/EncounterUI/VSplitContainer/VBoxContainer2/Panel/MarginContainer/ButtonsContainer/MainButtonContainer/MainButton
onready var ui = $CanvasLayer/EncounterUI
onready var ui_node = find_parent("SceneManager").find_node("UI").get_node("AnalogPad")
onready var enemyLifebar = $CanvasLayer/EncounterUI/VSplitContainer/VBoxContainer/MarginContainer/EnemyContainer/VBoxContainer/LifeBar

var current_state = null
enum BATTLE_STATES {
	PLAYER,
	ENEMY,
	WIN,
	LOSE
}

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_signals()
	
	# hide the analog pad
	ui_node.visible = false
	
	# populate the ui at start
	initializeUI()
	
	# set the starting state to the player
	handle_state(BATTLE_STATES.PLAYER)

func initializeUI():
	# set enemy sprite
	var enemySprite = $CanvasLayer/EncounterUI/VSplitContainer/VBoxContainer/MarginContainer/EnemyContainer/EnemySprite/TextureRect
	enemySprite.set_texture(load(Rules.nextMonster["sprite"]))
	
	# set enemy monster name
	var enemyName = $CanvasLayer/EncounterUI/VSplitContainer/VBoxContainer/MarginContainer/EnemyContainer/VBoxContainer/EnemyMonsterLabel
	enemyName.text = str(Rules.nextMonster["monster_name"])
	
	var playerSprite = $CanvasLayer/EncounterUI/VSplitContainer/VBoxContainer/MarginContainer2/PlayerContainer/PlayerSprite/TextureRect
	playerSprite.set_texture(load(PlayerData.playerParty[0]["sprite"]))
	
	# set player monster name
	var playerName = $CanvasLayer/EncounterUI/VSplitContainer/VBoxContainer/MarginContainer2/PlayerContainer/VBoxContainer/PlayerMonsterLabel
	playerName.text = str(PlayerData.playerParty[0]["monster_name"])

func handle_state(new_state):
	$CanvasLayer/BATTLE_STATE.text = str(BATTLE_STATES.keys()[new_state])
	current_state = new_state
	
	match current_state:
		BATTLE_STATES.PLAYER:
			# Player code here
			dialogBox.text = "What will you do?\nChoose an action!"
			attackButton.disabled = false
			pass
		BATTLE_STATES.ENEMY:
			# Enemy code here
			dialogBox.text = "What will the enemy do?"
			attackButton.disabled = true
			yield(get_tree().create_timer(1.5), "timeout")
			dialogBox.text = "enemy is thinking..."
			yield(get_tree().create_timer(1.5), "timeout")
			dialogBox.text = "enemy did nothing!"
			yield(get_tree().create_timer(1.5), "timeout")
			handle_state(BATTLE_STATES.PLAYER)
			pass
		BATTLE_STATES.WIN:
			# Win code here
			dialogBox.text = "You won!"
			get_node(NodePath("/root/SceneManager")).transition_to_scene("res://scenes/Map.tscn")
			ui_node.visible = true
			# play animation...
			# get xp...
			# leave scene...
			pass
		BATTLE_STATES.LOSE:
			# Lose code here
			print("You lost...")
			# remove some money...
			# find nearest hospital...
			# respawn player
			pass

func connect_signals():
	ui.connect("has_attacked_signal", self, "_on_playerAttack")

func _on_playerAttack():
	print("player attack signal")
	# play attack animation on player...
	
	# make damage to enemy
	enemyLifebar.value -= 27
	
	if enemyLifebar.value <= 0:
		handle_state(BATTLE_STATES.WIN)
	else:
		handle_state(BATTLE_STATES.ENEMY)

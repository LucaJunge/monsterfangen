extends Node2D

# debug signal for enemy actions
signal timeout

onready var dialogBox = $CanvasLayer/EncounterUI/VSplitContainer/ButtonContainer/PanelContainer/DialogText
onready var attackButton = $CanvasLayer/EncounterUI/VSplitContainer/ButtonContainer/Panel/ButtonsContainer/FightButtonMarginContainer/FightButton
onready var ui = $CanvasLayer/EncounterUI
onready var ui_node = find_parent("SceneManager").find_node("UI").get_node("Joystick")
onready var menu_button = find_parent("SceneManager").find_node("UI").get_node("MenuButton")
onready var enemyLifebar = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/EnemyMarginContainer/EnemyContainer/EnemyInfo/EnemyHealth
onready var actionButton = find_parent("SceneManager").find_node("UI").get_node("ActionsButton")
# manage the current encounter state
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
	# todo: DO THIS IN THE SCENE MANAGER OR SOMEWHERE ELSE
	ui_node.visible = false
	menu_button.visible = false
	actionButton.visible = false
	
	# populate the ui at start
	initializeUI()
	
	# set the starting state to the player
	handle_state(BATTLE_STATES.PLAYER)

func initializeUI():
	# set enemy sprite
	var enemySprite = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/EnemyMarginContainer/EnemyContainer/EnemySpriteContainer/EnemySprite
	enemySprite.set_texture(load(Rules.nextMonster["sprite"]))
	
	# set enemy monster name
	var enemyName = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/EnemyMarginContainer/EnemyContainer/EnemyInfo/EnemyName
	enemyName.text = str(Rules.nextMonster["monster_name"])
	
	# set enemy level
	var enemyLevel = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/EnemyMarginContainer/EnemyContainer/EnemyInfo/EnemyLevel
	enemyLevel.text = "Lv" + str(Rules.nextMonster["level"])
	
	# set player sprite
	var playerSprite = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerSpriteContainer/PlayerSprite
	playerSprite.set_texture(load(PlayerData.playerParty[0]["sprite"]))
	
	# set player monster name
	var playerName = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerInfo/PlayerName
	playerName.text = str(PlayerData.playerParty[0]["monster_name"])
	
	# set player level
	var playerLevel = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerInfo/PlayerLevel
	playerLevel.text = "Lv" + str(PlayerData.playerParty[0]["level"])

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
			if enemyLifebar.value <= 0:
				handle_state(BATTLE_STATES.WIN)
				
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
			# play animation...
			print(PlayerData.playerParty[0].current_xp)
			print(PlayerData.playerParty[0].level)
			var xp = PlayerData.playerParty[0].calculate_xp(Rules.nextMonster)
			PlayerData.playerParty[0].add_xp(xp)
			print(PlayerData.playerParty[0].current_xp)
			print(PlayerData.playerParty[0].level)
			# get xp...
			# leave scene...
			# recruit chance based on monster type?
			# random? player/monster level? skilling?
			get_node(NodePath("/root/SceneManager")).transition_to_scene("res://scenes/World/World1/World1.tscn")
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
	ui.connect("wants_to_flee", self, "flee")

func _on_playerAttack():
	print("Player attacked")
	# play attack animation on player...
	
	# make damage to enemy
	enemyLifebar.value -= 27
	
	# change to the enemy state
	handle_state(BATTLE_STATES.ENEMY)

# should this be another battle_state?
func flee():
	dialogBox.text = "You fled!"
	get_node(NodePath("/root/SceneManager")).transition_to_scene("res://scenes/World/World1/World1.tscn", true)

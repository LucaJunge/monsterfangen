extends Node2D

# debug signal for enemy actions
signal timeout

onready var dialogBox = $CanvasLayer/EncounterUI/VSplitContainer/ButtonContainer/PanelContainer/DialogText
onready var attackButton = $CanvasLayer/EncounterUI/VSplitContainer/ButtonContainer/Panel/ButtonsContainer/FightButtonMarginContainer/FightButton

# maybe call a function of the scene manager, something like show_ui() or disable_ui()?
onready var joystick = find_parent("SceneManager").find_node("UI").get_node("Joystick")
onready var menu_button = find_parent("SceneManager").find_node("UI").get_node("MenuButton")
onready var actionButton = find_parent("SceneManager").find_node("UI").get_node("ActionsButton")
onready var enemy_lifebar = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/EnemyMarginContainer/EnemyContainer/EnemyInfo/EnemyHealth

# who is the player monster? currently always [0] in the array
onready var player_monster = PlayerData.playerParty[0]

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
	# hide the ui
	# todo: DO THIS IN THE SCENE MANAGER OR SOMEWHERE ELSE
	joystick.visible = false
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
	
	# set enemy life
	var enemyLife = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/EnemyMarginContainer/EnemyContainer/EnemyInfo/EnemyHealth
	enemyLife.max_value = Rules.nextMonster["health"]
	enemyLife.value = Rules.nextMonster["current_health"]
	print(enemyLife.value)
	
	# set player sprite
	var playerSprite = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerSpriteContainer/PlayerSprite
	playerSprite.set_texture(load(PlayerData.playerParty[0]["sprite"]))
	
	# set player monster name
	var playerName = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerInfo/PlayerName
	playerName.text = str(PlayerData.playerParty[0]["monster_name"])
	
	# set player level
	var playerLevel = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerInfo/PlayerLevel
	playerLevel.text = "Lv" + str(PlayerData.playerParty[0]["level"])
	
	# set player life
	var playerLife = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerInfo/PlayerHealth
	playerLife.max_value = PlayerData.playerParty[0]["health"]
	playerLife.value = PlayerData.playerParty[0]["current_health"]
	

func handle_state(new_state):
	current_state = new_state
	
	match current_state:
		BATTLE_STATES.PLAYER:
			# Player code here
			
			if player_monster.current_health <= 0:
				handle_state(BATTLE_STATES.LOSE)
				
			dialogBox.text = "What will you do?\nChoose an action!"
			attackButton.disabled = false
			pass
		BATTLE_STATES.ENEMY:
			# Enemy code here
			if Rules.nextMonster.current_health <= 0:
				handle_state(BATTLE_STATES.WIN)
			
			dialogBox.text = "What will the enemy do?"
			attackButton.disabled = true
			
			yield(get_tree().create_timer(1.5), "timeout")
			var damage = Rules.nextMonster.attack(player_monster)
			#print_debug("damage from enemey", damage)
			player_monster.take_damage(damage)
			
			$CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerInfo/PlayerHealth.value = player_monster.current_health
			
			handle_state(BATTLE_STATES.PLAYER)
			pass
		BATTLE_STATES.WIN:
			# Win code here
			dialogBox.text = "You won!"
			# play animation...
			var xp = PlayerData.playerParty[0].calculate_xp(Rules.nextMonster)
			PlayerData.playerParty[0].add_xp(xp)
			# get xp...
			# leave scene...
			# recruit chance based on monster type?
			# random? player/monster level? skilling?
			$AnimationPlayer.play("fade_out_music")
			get_node(NodePath("/root/SceneManager")).transition_to_scene("res://scenes/World/World1/World1.tscn")
			pass
		BATTLE_STATES.LOSE:
			# Lose code here
			print("You lost...")
			# remove some money...
			# find nearest hospital...
			# respawn player
			$AnimationPlayer.play("fade_out_music")
			get_node(NodePath("/root/SceneManager")).transition_to_scene("res://scenes/World/World1/World1.tscn")
			pass

func _on_RunButton_button_up():
	if rand_range(0.0, 1.0) > 0.5:
		dialogBox.text = "You fled!"
		get_node(NodePath("/root/SceneManager")).transition_to_scene("res://scenes/World/World1/World1.tscn", true)
	else:
		dialogBox.text = "You can't flee!"
		yield(get_tree().create_timer(1.5), "timeout")
		handle_state(BATTLE_STATES.ENEMY)

func _on_FightButton_button_up():
	# play attack animation on player...
	
	# make damage to enemy
	var damage = player_monster.attack(Rules.nextMonster)
	print(damage)
	
	Rules.nextMonster.take_damage(damage)
	
	# updat the lifebar with the new value
	enemy_lifebar.value = Rules.nextMonster.current_health
	
	# change to the enemy state
	handle_state(BATTLE_STATES.ENEMY)

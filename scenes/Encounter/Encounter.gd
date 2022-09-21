extends Node2D

# debug signal for enemy actions
signal timeout

onready var dialogBox = $CanvasLayer/EncounterUI/VSplitContainer/ButtonContainer/PanelContainer/DialogText
onready var attackButton = $CanvasLayer/EncounterUI/VSplitContainer/ButtonContainer/Panel/ButtonsContainer/FightButtonMarginContainer/FightButton

# maybe call a function of the scene manager, something like show_ui() or disable_ui()?
# get_node("root/SceneManager")
onready var joystick = find_parent("SceneManager").find_node("UI").get_node("Joystick")
onready var menu_button = find_parent("SceneManager").find_node("UI").get_node("MenuButton")
onready var actionButton = find_parent("SceneManager").find_node("UI").get_node("ActionsButton")
onready var enemy_lifebar = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/EnemyMarginContainer/EnemyContainer/EnemyInfo/EnemyHealth
onready var sound_effect_player = $SoundEffectPlayer
onready var music_player = $MusicPlayer

onready var bag_button = $CanvasLayer/EncounterUI/VSplitContainer/ButtonContainer/Panel/ButtonsContainer/MarginContainer/OtherButtonsContainer/BagButton
onready var run_button = $CanvasLayer/EncounterUI/VSplitContainer/ButtonContainer/Panel/ButtonsContainer/MarginContainer/OtherButtonsContainer/RunButton
onready var team_button = $CanvasLayer/EncounterUI/VSplitContainer/ButtonContainer/Panel/ButtonsContainer/MarginContainer/OtherButtonsContainer/TeamButton

onready var level_up_sound = preload("res://assets/sounds/confirmation_002.ogg")
onready var hit_sound = preload("res://assets/sounds/hit.wav")

var timer_time = 2.0

# who is the player monster? currently always [0] in the array
#onready var player_monster = PlayerData.playerParty[0]

# manage the current encounter state
var current_state = null
enum BATTLE_STATES {
	INIT,
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
	
	# connect signals
	player_monster.connect("level_up_signal", self, "level_up")
	
	# set the starting state to the player
	handle_state(BATTLE_STATES.INIT)

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
	#print(enemyLife.value)
	
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
	
	# set player health as text
	var player_health_text = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerInfo/PlayerHealthText
	player_health_text.text = str(PlayerData.playerParty[0]["current_health"]) + " / " + str(PlayerData.playerParty[0]["health"])


func handle_state(new_state):
	current_state = new_state
	
	match current_state:
		BATTLE_STATES.INIT:
			
			disable_buttons(true)
			# play monster entry animation
			# update ui ("a wild xyz appears / ")
			var dialogBoxText = "A wild %s appeared"
			dialogBox.text = dialogBoxText % Rules.nextMonster["monster_name"]
			yield(get_tree().create_timer(timer_time), "timeout")
			handle_state(BATTLE_STATES.PLAYER)
			pass
			
		BATTLE_STATES.PLAYER:
			disable_buttons(false)
			
			# debug audio playing
			#playSound(level_up_sound)
			
			if player_monster.current_health <= 0:
				handle_state(BATTLE_STATES.LOSE)
				return # is this correct? otherwise the text will be set to the statement below (l. 123)
				
			dialogBox.text = "What will you do?\nChoose an action!"
			pass
		BATTLE_STATES.ENEMY:
			disable_buttons(true)
			
			if Rules.nextMonster.current_health <= 0:
				handle_state(BATTLE_STATES.WIN)
				continue
				
			dialogBox.text = "What will the enemy do?"
			
			yield(get_tree().create_timer(timer_time), "timeout")
			var damage = Rules.nextMonster.attack_enemy(player_monster)
			dialogBox.text = "The enemy attacked you!"
			#print_debug("damage from enemey", damage)
			playSoundOverMusic(hit_sound)
			player_monster.take_damage(damage)
			$AnimationPlayer.play("take_damage_player")
			
			$CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerInfo/PlayerHealth.value = player_monster.current_health
			
			var player_health_text = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerInfo/PlayerHealthText
			player_health_text.text = str(PlayerData.playerParty[0]["current_health"]) + " / " + str(PlayerData.playerParty[0]["health"])
						
			yield(get_tree().create_timer(timer_time / 2.0), "timeout")
			
			handle_state(BATTLE_STATES.PLAYER)
			pass
		BATTLE_STATES.WIN:
			disable_buttons(true)
			dialogBox.text = "You won!"
			
			yield(get_tree().create_timer(timer_time), "timeout")
			
			# play animation...
			var xp = player_monster.calculate_xp(Rules.nextMonster)
			player_monster.add_xp(xp)
			
			# recruit chance based on monster type?
			# random? player/monster level? skilling?
			
			yield(get_tree().create_timer(timer_time), "timeout")
			$AnimationPlayer.play("fade_out_music")
			get_node(NodePath("/root/SceneManager")).transition_to_scene("res://scenes/World/World1/World1.tscn")
			pass
		BATTLE_STATES.LOSE:
			disable_buttons(true)
			dialogBox.text = "You lost!"
			
			# remove some money...
			# find nearest hospital...
			# respawn player
			$AnimationPlayer.play("die_player")
			yield(get_tree().create_timer(timer_time), "timeout")
			$AnimationPlayer.play("fade_out_music")
			
			# set position to nearest hospital
			#PlayerData.playerPosition = nearest_hospital_spawn.position
			
			get_node(NodePath("/root/SceneManager")).transition_to_scene("res://scenes/World/World1/World1.tscn")
			pass

func _on_RunButton_button_up():
	if rand_range(0.0, 1.0) > 0.5:
		dialogBox.text = "You fled!"
		disable_buttons(true)
		get_node(NodePath("/root/SceneManager")).transition_to_scene("res://scenes/World/World1/World1.tscn", true)
	else:
		dialogBox.text = "You can't flee!"
		disable_buttons(true)
		yield(get_tree().create_timer(timer_time), "timeout")
		handle_state(BATTLE_STATES.ENEMY)

func _on_FightButton_button_up():
	# play attack animation on player...
	
	# make damage to enemy
	var damage = player_monster.attack_enemy(Rules.nextMonster)
	#print(damage)
	
	dialogBox.text = "You attacked!"
	playSoundOverMusic(hit_sound)
	Rules.nextMonster.take_damage(damage)
	$AnimationPlayer.play("take_damage_enemy")
	disable_buttons(true)
		
	# update the lifebar with the new value
	enemy_lifebar.value = Rules.nextMonster.current_health
	
	# placeholder for progress bar animation
	yield(get_tree().create_timer(timer_time / 2.0), "timeout")
	
	# change to the enemy state
	handle_state(BATTLE_STATES.ENEMY)


func disable_buttons(value):
	bag_button.disabled = value
	run_button.disabled = value
	team_button.disabled = value
	attackButton.disabled = value
	
func playSound(stream: AudioStream):
	music_player.volume_db = -10
	sound_effect_player.stream = stream
	sound_effect_player.play()
	music_player.volume_db = 0

# play sound without turning down volume of the music
func playSoundOverMusic(stream: AudioStream):
	sound_effect_player.stream = stream
	sound_effect_player.play()
	pass
	
func level_up():
	# update ui
	var dialogBoxText = "%s reached level %s!"
	dialogBox.text = dialogBoxText % [PlayerData.playerParty[0]["monster_name"], str(PlayerData.playerParty[0]["level"])]
	# play sound
	var playerLevel = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerInfo/PlayerLevel
	playerLevel.text = "Lv" + str(PlayerData.playerParty[0]["level"])
	
	var player_health_text = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerInfo/PlayerHealthText
	player_health_text.text = str(PlayerData.playerParty[0]["current_health"]) + " / " + str(PlayerData.playerParty[0]["health"])
	
	var player_health = $CanvasLayer/EncounterUI/VSplitContainer/MonsterContainer/PlayerMarginContainer/PlayerContainer/PlayerInfo/PlayerHealth
	player_health.max_value = PlayerData.playerParty[0]["health"]
	player_health.value = player_monster.current_health
	
	playSound(level_up_sound)
	pass

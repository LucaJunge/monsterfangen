extends CanvasLayer

onready var run_sound = preload("res://assets/sounds/run.wav")
onready var hit_sound = preload("res://assets/sounds/hit.wav")
onready var main_theme = preload("res://assets/music/edwinnington_a_theme.mp3")

# all UI buttons
onready var fight_button = get_node("%FightButton")
onready var monster_button = get_node("%MonsterButton")
onready var bag_button = get_node("%BagButton")
onready var run_button = get_node("%RunButton")

var enemy_monster: Monster = null
var player_monster: Monster = null
var party: Party = null

var timer_time: float = 2.0

var current_state = null
enum BATTLE_STATES {
	INIT,
	PLAYER,
	ENEMY,
	CATCH
	WIN,
	LOSE
}

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false

# initializes the scene on a triggered encounter (e.g. from a tall grass node)
func init(_enemy_monster: Monster, _player_monster: Monster, _party: Party) -> void:
	enemy_monster = _enemy_monster
	player_monster = _player_monster
	party = _party
	_set_enemy_monster(enemy_monster)
	_set_player_monster(player_monster)
	_handle_state(BATTLE_STATES.INIT)


func _set_enemy_monster(enemy_monster: Monster) -> void:
	get_node("%EnemyMonsterName").text = enemy_monster.display_name
	get_node("%EnemyMonsterIcon").texture = enemy_monster.icon
	get_node("%EnemyMonsterLevel").text = "Lv. " + str(enemy_monster.level)
	get_node("%EnemyMonsterHealthbar").max_value = enemy_monster.health
	get_node("%EnemyMonsterHealthbar").value = enemy_monster.current_health
	

func _set_player_monster(player_monster: Monster) -> void:
	get_node("%PlayerMonsterName").text = player_monster.display_name
	get_node("%PlayerMonsterHealthLabel").text = str(player_monster.current_health) + " / " + str(player_monster.health)
	get_node("%PlayerMonsterIcon").texture = player_monster.icon
	get_node("%PlayerMonsterLevel").text = "Lv. " + str(player_monster.level)
	get_node("%PlayerMonsterHealthbar").max_value = player_monster.health
	get_node("%PlayerMonsterHealthbar").value = player_monster.current_health
	get_node("%PlayerMonsterExp").min_value = player_monster._needed_xp_for_levelup(player_monster.level - 1)
	get_node("%PlayerMonsterExp").max_value = player_monster._needed_xp_for_levelup()
	get_node("%PlayerMonsterExp").value = player_monster.xp

func _handle_state(new_state):
	current_state = new_state

	match current_state:
		BATTLE_STATES.INIT:
			disable_buttons(true)
			var dialogBoxText = "A wild %s appeared!"
			get_node("%DialogText").text = dialogBoxText % enemy_monster.display_name
			# + 1,2 because the "foliage" animation takes this long to reveal this scene
			yield(get_tree().create_timer(timer_time + 1.2), "timeout")
			_handle_state(BATTLE_STATES.PLAYER)
			pass
		
		BATTLE_STATES.PLAYER:
			disable_buttons(false)

			if player_monster.current_health <= 0:
				_handle_state(BATTLE_STATES.LOSE)
				return # is this correct? otherwise the text will be set to the statement below (l. 123)
			
			get_node("%DialogText").text = "What will you do?\nChoose an action!"
			pass
		
		BATTLE_STATES.ENEMY:
			disable_buttons(true)

			if enemy_monster.current_health <= 0:
				_handle_state(BATTLE_STATES.WIN)
				continue
			
			get_node("%DialogText").text = "What will %s do?" % enemy_monster.display_name
			
			yield(get_tree().create_timer(timer_time), "timeout")

			# let the enemy attack you
			var damage = enemy_monster.attack(player_monster)
			print_debug("Enemy made %s damage" % damage)
			get_node("%DialogText").text = "%s attacked you!" % enemy_monster.display_name

			AudioManager.play(hit_sound)
			player_monster.take_damage(damage)
			_set_player_monster(player_monster)

			# TODO: update ui here...

			yield(get_tree().create_timer(timer_time / 2.0), "timeout")
			_handle_state(BATTLE_STATES.PLAYER)
			pass
		
		BATTLE_STATES.CATCH:
			disable_buttons(true)
			get_node("%DialogText").text = "%s was caught!" % enemy_monster.display_name
			
			# play some sound...
			
			# add monster to the party
			print(enemy_monster.current_health)
			print(enemy_monster.health)
			
			var monster: Monster = Monster.new(enemy_monster.unique_id, {"current_health": enemy_monster.current_health, "health": enemy_monster.health, "xp": 0}, enemy_monster.level)
			
			if not party.is_full():
				get_node("%DialogText").text = "%s was added to your party!" % enemy_monster.display_name
				yield(get_tree().create_timer(timer_time), "timeout")
				party.append_member(monster)
			else:
				# else: dialog, to add to pc
				get_node("%DialogText").text = "Your party is full. %s was saved to the PC!" % enemy_monster.display_name
				# todo: save monster to the pc
			
			yield(get_tree().create_timer(timer_time * 1.5), "timeout")
			_exit_scene()
			pass
		BATTLE_STATES.WIN:
			disable_buttons(true)
			get_node("%DialogText").text = "%s was defeated" % enemy_monster.display_name

			yield(get_tree().create_timer(timer_time), "timeout")

			var xp = player_monster.calculate_gained_xp(enemy_monster)
			player_monster.add_xp(xp)
			_set_player_monster(player_monster)
			yield(get_tree().create_timer(timer_time), "timeout")

			_exit_scene()
			
		BATTLE_STATES.LOSE:
			disable_buttons(true)
			get_node("%DialogText").text = "%s defeated you!" % enemy_monster.display_name

			# remove some money...
			# find nearest hospital...
			# respawn player...

			yield(get_tree().create_timer(timer_time * 1.5), "timeout")
			_exit_scene()
			pass


func disable_buttons(disable: bool = true):
	fight_button.disabled = disable
	monster_button.disabled = disable
	bag_button.disabled = disable
	run_button.disabled = disable
	
func _exit_scene() -> void:
	SceneTransition.change_overlay(self, "fade")
	AudioManager.stop()
	AudioManager.play_loop(main_theme)

	var player = Utils.get_player_node()
	player.enable_movement()
	
func _on_RunButton_pressed() -> void:
	if rand_range(0.0, 1.0) > 0.1:
		get_node("%DialogText").text = "You fled!"
		disable_buttons(true)
		AudioManager.play(run_sound)
		_exit_scene()
	else:
		get_node("%DialogText").text = "You can't flee!"
		disable_buttons(true)
		yield(get_tree().create_timer(timer_time), "timeout")
		_handle_state(BATTLE_STATES.ENEMY)

func _on_FightButton_pressed():
	var damage = player_monster.attack(enemy_monster)
	
	var text = "%s attacked the wild %s" % [player_monster.display_name, enemy_monster.display_name]
	get_node("%DialogText").text = text
	AudioManager.play(hit_sound)
	
	print_debug(damage)
	enemy_monster.take_damage(damage)
	_set_enemy_monster(enemy_monster)
	disable_buttons(true)
	
	# update the lifebar with the new value
	#enemy_lifebar.value = Rules.nextMonster.current_health
	
	# placeholder for progress bar animation
	yield(get_tree().create_timer(timer_time / 2.0), "timeout")
	
	_handle_state(BATTLE_STATES.ENEMY)
	pass # Replace with function body.


func _on_MonsterButton_pressed():
	pass # Replace with function body.


func _on_BagButton_pressed():
	disable_buttons(true)
	# open menu to choose item... or CatchNet
	# play catch animation
	var text = "You threw a CatchNet on the wild %s!" % enemy_monster.display_name
	get_node("%DialogText").text = text
	
	# AudioManager.play("throwing_net_sound.wav")
	# replace the monster sprite with the catch net anticipation animation
	# calculate catch possibility
	
	# a timeout as a placeholder for the above steps
	yield(get_tree().create_timer(timer_time), "timeout")
	
	
	text = "The wild %s fights against the net!" % enemy_monster.display_name
	get_node("%DialogText").text = text
	
	# move the net
	# another placeholder for the above steps
	yield(get_tree().create_timer(timer_time), "timeout")
	
	
	var catch_possibility = rand_range(0.0, 1.0)
	if catch_possibility > 0.0:
		text = "The wild %s was caught!" % enemy_monster.display_name
		get_node("%DialogText").text = text
		
		# You "won", handle the catching of the monster
		#_handle_state(BATTLE_STATES.WIN)
		_handle_state(BATTLE_STATES.CATCH)
	else:
		text = "Oh no! The wild %s broke out!" % enemy_monster.display_name
		get_node("%DialogText").text = text
		
		# swap the sprite back to the monster, placeholder here
		yield(get_tree().create_timer(timer_time), "timeout")
		
		# The monster was not catched, so it's the enemies turn
		_handle_state(BATTLE_STATES.ENEMY)
	
	yield(get_tree().create_timer(timer_time), "timeout")
	
	pass # Replace with function body.

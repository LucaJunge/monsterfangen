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
var your_monster: Monster = null

var timer_time: float = 2.0

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
	self.visible = false

# initializes the scene on a triggered encounter (e.g. from a tall grass node)
func init(_enemy_monster: Monster, _your_monster: Monster) -> void:
	enemy_monster = _enemy_monster
	your_monster = _your_monster
	_set_enemy_monster(enemy_monster)
	_set_your_monster(your_monster)
	_handle_state(BATTLE_STATES.INIT)


func _set_enemy_monster(enemy_monster: Monster) -> void:
	get_node("%EnemyMonsterName").text = enemy_monster.display_name
	get_node("%EnemyMonsterHealthLabel").text = str(enemy_monster.health) + " / " + str(enemy_monster.health)
	get_node("%EnemyMonsterIcon").texture = enemy_monster.icon

func _set_your_monster(your_monster: Monster) -> void:
	get_node("%YourMonsterName").text = your_monster.display_name
	get_node("%YourMonsterHealthLabel").text = str(your_monster.health) + " / " + str(your_monster.health)
	get_node("%YourMonsterIcon").texture = your_monster.icon

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

			if your_monster.current_health <= 0:
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
			var damage = enemy_monster.attack(your_monster)
			print_debug("ebeny", damage)
			get_node("%DialogText").text = "%s attacked you!" % enemy_monster.display_name

			AudioManager.play(hit_sound)
			your_monster.take_damage(damage)

			# TODO: update ui here...

			yield(get_tree().create_timer(timer_time / 2.0), "timeout")
			_handle_state(BATTLE_STATES.PLAYER)
			pass
		BATTLE_STATES.WIN:
			disable_buttons(true)
			get_node("%DialogText").text = "%s was defeated" % enemy_monster.display_name

			yield(get_tree().create_timer(timer_time), "timeout")

			var xp = your_monster.calculate_gained_xp(enemy_monster)
			your_monster.add_xp(xp)

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
	
func _on_RunButton_pressed() -> void:
	if rand_range(0.0, 1.0) > 0.5:
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
	var damage = your_monster.attack(enemy_monster)
	
	var text = "%s attacked the wild %s" % [your_monster.display_name, enemy_monster.display_name]
	get_node("%DialogText").text = text
	AudioManager.play(hit_sound)
	
	print_debug(damage)
	enemy_monster.take_damage(damage)
	
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
	pass # Replace with function body.

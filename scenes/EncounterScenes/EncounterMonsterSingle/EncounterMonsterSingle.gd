extends CanvasLayer

onready var run_sound = preload("res://assets/sounds/run.wav")
onready var main_theme = preload("res://assets/music/edwinnington_a_theme.mp3")
# Called when the node enters the scene tree for the first time.

func _ready():
	self.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func init(enemy_monster: Monster, your_monster: Monster) -> void:
	_set_enemy_monster(enemy_monster)
	_set_your_monster(your_monster)

func _on_RunButton_pressed() -> void:
	AudioManager.play(run_sound)
	_exit_scene()

func _exit_scene() -> void:
	SceneTransition.change_overlay(self, "fade")
	AudioManager.stop()
	AudioManager.play_loop(main_theme)

func _set_enemy_monster(enemy_monster: Monster) -> void:
	get_node("%EnemyMonsterName").text = enemy_monster.display_name
	get_node("%EnemyMonsterHealth").text = str(enemy_monster.health) + " / " + str(enemy_monster.health)
	get_node("%EnemyMonsterIcon").texture = enemy_monster.icon

func _set_your_monster(your_monster: Monster) -> void:
	get_node("%YourMonsterName").text = your_monster.display_name
	get_node("%YourMonsterHealth").text = str(your_monster.health) + " / " + str(your_monster.health)
	get_node("%YourMonsterIcon").texture = your_monster.icon

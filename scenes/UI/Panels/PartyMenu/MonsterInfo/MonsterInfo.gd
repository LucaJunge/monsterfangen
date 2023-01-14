extends PanelContainer

onready var monster_icon = get_node("%MonsterIcon")
onready var monster_name = get_node("%MonsterName")
onready var monster_health = get_node("%MonsterHealth")
onready var monster_health_bar = get_node("%MonsterHealthBar")
onready var monster_experience_bar = get_node("%MonsterExperienceBar")
onready var monster_level = get_node("%MonsterLevel")
var monster

signal change_detail

func _ready():
	pass # Replace with function body.
	

func populate(_monster: Monster) -> void:
	monster = _monster
	monster_icon.texture = _monster.icon
	monster_name.text = _monster.display_name
	monster_health.text = str(_monster.current_health) + " / " + str(_monster.health)
	monster_level.text = "Lv." + str(_monster.level)
	
	var hp_percentage = floor(float(_monster.current_health) / float(_monster.health) * 100)
	monster_health_bar.value = hp_percentage
	
	var xp_percentage = floor(float(_monster.xp) / float(_monster._needed_xp_for_levelup()) * 100)
	monster_experience_bar.value = xp_percentage

func _on_MonsterInfo_gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		AudioManager.play_click()
		emit_signal("change_detail", monster)

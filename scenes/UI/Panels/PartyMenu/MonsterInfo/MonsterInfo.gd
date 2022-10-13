extends PanelContainer

onready var monster_icon = get_node("%MonsterIcon")
onready var monster_name = get_node("%MonsterName")
onready var monster_health = get_node("%MonsterHealth")
onready var monster_health_bar = get_node("%MonsterHealthBar")
onready var monster_level = get_node("%MonsterLevel")


func _ready():
	pass # Replace with function body.
	

func populate(monster: Object) -> void:
	monster_icon.texture = monster.icon
	monster_name.text = monster.display_name
	monster_health.text = str(monster.current_health) + " / " + str(monster.health)
	monster_level.text = "Lv." + str(monster.level)
	
	var percentage = floor(float(monster.current_health) / float(monster.health) * 100)
	monster_health_bar.value = percentage

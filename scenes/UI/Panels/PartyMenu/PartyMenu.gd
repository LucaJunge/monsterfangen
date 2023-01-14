extends Panel

onready var click = load("res://assets/sounds/click.wav")
onready var monster_info = load("res://scenes/UI/Panels/PartyMenu/MonsterInfo/MonsterInfo.tscn")

onready var monster_container = get_node("%MonsterContainer")
onready var atk_value = get_node("%ATKValue")
onready var hp_value = get_node("%HPValue")
onready var xp_value = get_node("%XPValue")
onready var def_value = get_node("%DEFValue")
onready var tmp_value = get_node("%TMPValue")
onready var level = get_node("%Level")
onready var detail_monster_icon = get_node("%DetailMonsterIcon")
onready var detail_monster_type1 = get_node("%TYPE1")
onready var detail_monster_type2 = get_node("%TYPE2")
onready var detail_monster_name = get_node("%DetailMonsterName")

func _ready():
	self.visible = false

func update_ui(party_members: Array) -> void:
	_clear_monster_container()
	
	for member in party_members:
		var info = monster_info.instance()
		monster_container.add_child(info)
		info.populate(member)
		info.connect("change_detail", self, "change_detail")

func _clear_monster_container() -> void:
	for child in monster_container.get_children():
		monster_container.remove_child(child)
		child.queue_free()

func _on_BackButton_pressed():
	AudioManager.play(click)
	SceneTransition.change_overlay(self, "fade")

func change_detail(monster: Monster) -> void:
	print(monster)
	detail_monster_icon.texture = monster. icon
	detail_monster_name.text = monster.display_name
	atk_value.text = str(monster.attack)
	xp_value.text = str(monster.xp) + " / " + str(monster._needed_xp_for_levelup())
	hp_value.text = str(monster.current_health) + " / " + str(monster.health)
	def_value.text = str(monster.defense)
	tmp_value.text = str(monster.tempo)
	level.text = "Lvl. " + str(monster.level)
	
	detail_monster_type1.text = str(MonsterType.Type.keys()[monster.primary_type])
	
	detail_monster_type2.text = str(MonsterType.Type.keys()[monster.secondary_type]) if not monster.secondary_type == MonsterType.Type.NONE else ""
	

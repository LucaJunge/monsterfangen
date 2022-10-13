extends Panel

onready var click = load("res://assets/sounds/click.wav")
onready var monster_info = load("res://scenes/UI/Panels/PartyMenu/MonsterInfo/MonsterInfo.tscn")

onready var monster_container = get_node("%MonsterContainer")

func _ready():
	self.visible = false

func update_ui(party_members: Array) -> void:
	_clear_monster_container()
	
	for member in party_members:
		var info = monster_info.instance()
		monster_container.add_child(info)
		info.populate(member)

func _clear_monster_container() -> void:
	for child in monster_container.get_children():
		monster_container.remove_child(child)
		child.queue_free()

func _on_BackButton_pressed():
	AudioManager.play(click)
	SceneTransition.change_overlay(self, "fade")

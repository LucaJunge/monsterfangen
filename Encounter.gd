extends Node2D

#var screenSize = null
#onready var screenSizeText = $CanvasLayer/ScreenSize
#onready var backgroundImage = $CanvasLayer/BackgroundImage

# Called when the node enters the scene tree for the first time.
func _ready():
	var ui_node = find_parent("SceneManager").find_node("UI").get_node("AnalogPad")
	print(ui_node)
	ui_node.visible = false
	
	# set enemy sprite
	var enemySprite = find_node("CanvasLayer").get_node("Control/VSplitContainer/VBoxContainer/MarginContainer/EnemyContainer/EnemySprite/TextureRect")
	enemySprite.set_texture(load(Rules.nextMonster["sprite"]))
	
	# set enemy monster name
	var enemyName = find_node("CanvasLayer").get_node("Control/VSplitContainer/VBoxContainer/MarginContainer/EnemyContainer/VBoxContainer/EnemyMonsterLabel")
	print(Rules.nextMonster["monster_name"])
	enemyName.text = str(Rules.nextMonster["monster_name"])
	
	var playerSprite = find_node("CanvasLayer").get_node("Control/VSplitContainer/VBoxContainer/MarginContainer2/PlayerContainer/PlayerSprite/TextureRect")
	print(playerSprite)
	playerSprite.set_texture(load(PlayerData.playerParty[0]["sprite"]))
	
	# set player monster name
	var playerName = find_node("CanvasLayer").get_node("Control/VSplitContainer/VBoxContainer/MarginContainer2/PlayerContainer/VBoxContainer/PlayerMonsterLabel")
	playerName.text = str(PlayerData.playerParty[0]["monster_name"])

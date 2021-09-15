extends PanelContainer

onready var sprite = $HBoxContainer/Sprite
onready var monster_name = $HBoxContainer/InfoGrid/HBoxContainer/monster_name
onready var monster_level = $HBoxContainer/InfoGrid/HBoxContainer/HBoxContainer/monster_level
onready var monster_gender = $HBoxContainer/InfoGrid/HBoxContainer/HBoxContainer/monster_gender
onready var hp_progressbar = $HBoxContainer/InfoGrid/hp_progressbar
onready var monster_hp = $HBoxContainer/InfoGrid/monster_hp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_info(_sprite = "res://assets/interface/missingno.png", _monster_name = "MISSINGNO", _monster_level = "-1", _monster_gender = "X", _monster_hp = "?" ):
	$HBoxContainer.visible = true
	sprite.set_texture(load(_sprite))
	monster_name.set_text(_monster_name)
	monster_level.set_text("Lv " + str(_monster_level))
	monster_gender.set_text(_monster_gender)
	monster_hp.set_text(str(_monster_hp)+ " / " + "??")

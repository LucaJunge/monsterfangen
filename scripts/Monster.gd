extends Node
class_name Monster, "res://assets/interface/monster.png"

#var variable = value setget setterfunc, getterfunc

var monster_name = "MISSINGNO"
var sprite = "res://assets/interface/missingno.png"
var base_attack = 1
var base_health = 1
var level = 1

func _init(dict):
	
	# set all values for one monster
	base_attack = dict["base_attack"]
	base_health = dict["base_health"]
	level = 1 # find a way to pass a level when creating a pokemon
	sprite = dict["sprite"]
	monster_name = dict["monster_name"]
	
	#print("New Monster created with " + String(baseAttack) + " baseAttack")
	
func attack():
	pass

func save():
	var save_dict = {
		"monster_name": monster_name,
		"sprite": sprite,
		"base_attack": base_attack,
		"base_health": base_health,
		"level": level
	}
	return save_dict
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

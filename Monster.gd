extends Node
class_name Monster, "res://assets/interface/monster.png"

#var variable = value setget setterfunc, getterfunc

var baseAttack = 1
var baseHealth = 1
var level = 1
var sprite = "res://assets/interface/missingno.png"
var monster_name = "MISSINGNO"

func _init(dict):
	
	# set all values for one monster
	baseAttack = dict["baseAttack"]
	baseHealth = dict["baseHealth"]
	level = 1 # find a way to pass a level when creating a pokemon
	sprite = dict["sprite"]
	monster_name = dict["name"]
	
	print("New Monster created with " + String(baseAttack) + " baseAttack")

func attack():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

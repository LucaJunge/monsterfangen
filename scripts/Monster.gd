extends Node
class_name Monster, "res://assets/interface/monster.png"

#var variable = value setget setterfunc, getterfunc

var monster_name = "MISSINGNO"
var sprite = "res://assets/interface/missingno.png"

# base values
var base_attack = 1
var base_health = 1
var base_defense = 1
var base_tempo = 1
var base_xp = 10
var level = 1

# current values
var current_xp = 0
var current_attack = 1
var current_health = 1
var current_defense = 1
var current_tempo = 1

func _init(dict):
	for key in dict.keys():
		#check if key is property of Monster, if it is, set it to value from dictionary
		if get(key):
			print(key + str(dict[key]))
			#print(str(key) + "exists")
			set(key, dict[key])
			
	if not dict.has("loading") or dict["loading"] == false:
		print("not loading from a savegame")
		set_statusvalues()
		set_current_xp()
		
	# set all values for one monster
	#base_attack = dict["base_attack"]
	#base_health = dict["base_health"]
	#level = 1 #dict["level"]
	#sprite = dict["sprite"]
	#monster_name = dict["monster_name"]
	#current_xp = 1 #dict["current_xp"]
	
	#print("New Monster created with " + String(baseAttack) + " baseAttack")
	
func attack():
	pass

func save():
	var save_dict = {
		"monster_name": monster_name,
		"sprite": sprite,
		"base_attack": base_attack,
		"base_health": base_health,
		"base_defense": base_defense,
		"base_tempo": base_tempo,
		"base_xp": base_xp,
		"level": level,
		"current_xp": current_xp,
		"current_attack": current_attack,
		"current_health": current_health,
		"current_defense": current_defense,
		"current_tempo": current_tempo
	}
	return save_dict
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _next_level_xp():
	var next_level_xp = int(pow(level+1, 3))
	return next_level_xp
	
func level_up():
	level = level + 1
	# change values for attack, defense etc.
	set_statusvalues()
	
func calculate_xp(monster: Monster):
	var calculated_xp: int = 0
	
	print(float(monster.level) / float(level))
	
	calculated_xp = int(ceil((float(monster.level) / float(level)) * monster.base_xp))
	return calculated_xp
	
func add_xp(amount: int = 0):
	current_xp += amount
	if(current_xp >= _next_level_xp()):
		level_up()
		
func set_statusvalues():
	current_attack = int((((base_attack * 2) * level ) / 100) + (level + 5))
	current_health = int((((base_health * 2) * level ) / 100) + (level + 5))
	current_defense = int((((base_defense * 2) * level ) / 100) + (level + 5))
	current_tempo = int((((base_tempo * 2) * level ) / 100) + (level + 5))
	
func set_current_xp():
	current_xp = int(pow(level, 3))
# level abbilden:
# wie verhalten sich die werte, wenn das level sich ändert? 
# linear annähern, 

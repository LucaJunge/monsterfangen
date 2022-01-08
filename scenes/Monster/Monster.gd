extends Node
class_name Monster, "res://assets/interface/monster.png"

#var variable = value setget setterfunc, getterfunc

signal level_up_signal

var monster_name = "MISSINGNO"
var sprite = "res://assets/interface/missingno.png"

# base values, will be overwritten
var base_attack = 1
var base_health = 1
var base_defense = 1
var base_tempo = 1
var base_xp = 10
var level = 1

# current values
var xp = 1
var attack = 1
var health = 1
var defense = 1
var tempo = 1

var current_health = 1
var nickname = monster_name

func _init(dict):
	for key in dict.keys():
		#check if key is property of Monster, if it is, set it to value from dictionary
		if get(key):
			#print(key + str(dict[key]))
			set(key, dict[key])
			
	if not dict.has("loading") or dict["loading"] == false:
		#print("not loading from a savegame")
		set_statusvalues()
		set_current_xp()
		current_health = health

func set_level(_level: int):
	level = _level
	set_statusvalues()
	set_current_xp()
	current_health = health

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
		"xp": xp,
		"attack": attack,
		"health": health,
		"current_health": current_health,
		"defense": defense,
		"tempo": tempo
	}
	return save_dict
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# calculates how much xp you need for the next level
func _next_level_xp():
	var next_level_xp = int(pow(level+1, 3))
	return next_level_xp
	
func level_up():
	level = level + 1
	# change values for attack, defense etc.
	set_statusvalues()
	emit_signal("level_up_signal")

# calculates the xp a monster would get from an enemy
func calculate_xp(enemy: Monster):
	var calculated_xp: int = 0
	
	# loosely based on https://www.pokewiki.de/Erfahrung#5._Generation
	calculated_xp = int((enemy.base_xp * enemy.level / 5) * (float(enemy.level) / float(level)))

	return calculated_xp
	
func add_xp(amount: int = 0):
	xp += amount
	if(xp >= _next_level_xp()):
		level_up()
		
func set_statusvalues():
	attack = int((((base_attack * 2) * level ) / 100) + (level + 5))
	health = int((((base_health * 2) * level ) / 100) + (level + 5))
	defense = int((((base_defense * 2) * level ) / 100) + (level + 5))
	tempo = int((((base_tempo * 2) * level ) / 100) + (level + 5))

# this is for enemy monsters, so that they have at least the xp for their current level
func set_current_xp():
	xp = int(pow(level, 3))

func attack_enemy(enemy_monster: Monster):
	#var damage = 0
	var damage_2 = 0
	
	# damage of the attack
	var base_damage = 2
	#var new_damage = 50 # damage of tackle
	
	#damage = base_damage * int(ceil(attack / float(enemy_monster.defense)))
	damage_2 = floor(floor((level * 2/5 + 2)) * base_damage * (float(attack) / (2 * enemy_monster.defense)) + 2)
	
	#print(str(damage) + " : " + str(damage_2))
	return damage_2

func take_damage(amount):
	current_health -= amount
	if(current_health < 0):
		current_health = 0

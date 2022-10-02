class_name Monster extends MonsterData

signal level_up

func _init(_unique_id = "", current_values: Dictionary = {}, _level: int = 1) -> void:
	if _unique_id.empty():
		printerr("Monster.gd: No ID given")
	
	# get the base class from the tres resources
	var base_monster = MonsterDatabase.get_monster_data(_unique_id)
	unique_id = base_monster.unique_id
	#print_debug(_unique_id)

	display_name = base_monster.display_name
	nickname = base_monster.nickname
	description = base_monster.description
	icon = base_monster.icon
	primary_type = base_monster.primary_type
	secondary_type = base_monster.secondary_type

	# base values
	base_attack = base_monster.base_attack
	base_health = base_monster.base_health
	base_defense = base_monster.base_defense
	base_tempo = base_monster.base_tempo
	base_xp = base_monster.base_xp

	# check if current_values is empty -> generate a completely new monster and set the values
	if current_values.empty():
		print_debug("create a new monster", _unique_id)
		_set_level(_level)
	else:
		# overwrite current values
		if(current_values.has("health")):
			health = current_values["health"]
		else:
			health = base_health
			
		if(current_values.has("attack")):
			attack = current_values["attack"]
		else:
			attack = base_attack
			
		if(current_values.has("xp")):
			xp = current_values["xp"]
		else:
			xp = base_xp
			
		if(current_values.has("defense")):
			defense = current_values["defense"]
		else:
			defense = base_defense
			
		if(current_values.has("tempo")):
			tempo = current_values["tempo"]
		else:
			tempo = base_tempo
			
		if(current_values.has("level")):
			level = current_values["level"]
		else:
			level = 1
			
		if(current_values.has("current_health")):
			current_health = current_values["current_health"]
		else:
			current_health = base_health

func _set_level(_level: int):
	level = _level
	_set_statusvalues(level)
	_set_current_xp()
	current_health = health
	
func _set_statusvalues(level: int):
	attack = int((((base_attack * 2) * level ) / 100) + (level + 5))
	health = int((((base_health * 2) * level ) / 100) + (level + 5))
	defense = int((((base_defense * 2) * level ) / 100) + (level + 5))
	tempo = int((((base_tempo * 2) * level ) / 100) + (level + 5))

func _set_current_xp():
	xp = int(pow(level, 3))

func _needed_xp_for_levelup(_level: int = level):
	var needed_xp_for_levelup = int(pow(_level+1, 3))
	return needed_xp_for_levelup

func _level_up():
	level = level +1
	_set_statusvalues(level)
	emit_signal("level_up")

# calculates the xp a monster would get from an enemy
func calculate_gained_xp(enemy: Monster):
	var calculated_xp: int = 0
	
	# loosely based on https://www.pokewiki.de/Erfahrung#5._Generation
	calculated_xp = int((enemy.base_xp * enemy.level / 5) * (float(enemy.level) / float(level)))

	return calculated_xp

func add_xp(amount: int = 0):
	xp += amount
	if(xp >= _needed_xp_for_levelup()):
		_level_up()


func attack(enemy_monster: Monster):
	var damage = 0
	
	# damage of the attack
	var base_damage = 2
	#var new_damage = 50 # damage of tackle
	
	#damage = base_damage * int(ceil(attack / float(enemy_monster.defense)))
	damage = floor(floor((level * 2/5 + 2)) * base_damage * (float(attack) / (2 * enemy_monster.defense)) + 2)
	
	#print_debug(str(damage) + " : " + str(damage_2))
	return damage
	
func take_damage(amount):
	current_health -= amount
	if(current_health < 0):
		current_health = 0

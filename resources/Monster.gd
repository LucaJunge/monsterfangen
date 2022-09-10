class_name Monster extends MonsterData

func _init(_unique_id = "", current_values: Dictionary = {}) -> void:
	if _unique_id.empty():
		printerr("Monster.gd: No ID given")
	
	# get the base class from the tres resources
	var base_monster = MonsterDatabase.get_monster_data(_unique_id)
	unique_id = base_monster.unique_id
	print_debug(_unique_id)

	display_name = base_monster.display_name
	nickname = base_monster.nickname
	description = base_monster.description
	icon = base_monster.icon
	type = base_monster.type

	# base values
	base_attack = base_monster.base_attack
	base_health = base_monster.base_health
	base_defense = base_monster.base_defense
	base_tempo = base_monster.base_tempo
	base_xp = base_monster.base_xp
	
	# overwrite current values
	
	if(current_values.has("health")):
		health = current_values["health"]
		
	if(current_values.has("attack")):
		attack = current_values["attack"]
		
	if(current_values.has("xp")):
		xp = current_values["xp"]
		
	if(current_values.has("defense")):
		defense = current_values["defense"]
		
	if(current_values.has("tempo")):
		tempo = current_values["tempo"]
		
	if(current_values.has("level")):
		level = current_values["level"]
		
	if(current_values.has("current_health")):
		current_health = current_values["current_health"]

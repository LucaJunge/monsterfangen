class_name Party
extends Resource

export var party := {
	#"0": {
	#	"unique_id": "treey",
	#	"display_name": "display_name",
	#	"level": 1
	#}
}


#func add_member(position: String, unique_id : String, display_name : String, level: int):
#
#	if not party.has(position):
#		party[position] = {
#			"unique_id": unique_id,
#			"display_name": display_name,
#			"level": level
#		}
#	else:
#		printerr("Party already contains monster at position %s" % position)

func add_member(position: String, monster_data : Dictionary):
	if not party.has(position): 
		
		# how to iterate over properties of a resource
		#var properties = monster_data.get_property_list()
		#for i in range(properties.size()):
		#	print(properties[i].name + ", type: " + str(properties[i].type) + " = " + str(monster_data.get(properties[i].name)))
		
		party[position] = {
			"unique_id": monster_data.unique_id,
			"display_name": monster_data.display_name,
			"nickname": monster_data.nickname,
			"description" : monster_data.description,
			"type": monster_data.type,
			"base_attack": monster_data.base_attack,
			"base_health" : monster_data.base_health,
			"base_defense": monster_data.base_defense,
			"base_tempo": monster_data.base_tempo,
			"base_xp": monster_data.xp,
			"xp" : monster_data.xp,
			"attack": monster_data.attack,
			"health": monster_data.health,
			"defense": monster_data.defense,
			"tempo": monster_data.tempo,
			"level": monster_data.level,
			"current_health": monster_data.current_health
		}
		
		#party["debug"] = monster_data
	else:
		printerr("Party already contains monster at position %s" % position)

#func swap_member()

#func remove_member()

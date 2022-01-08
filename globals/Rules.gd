extends Node

# Global configuration

var encounterRate = 0.1
var nextMonster = null

var monsterDictionary = {
	"0": {
		"id": 0,
		"monster_name": "Dreamer",
		"base_attack": 40,
		"base_health": 60,
		"base_defense": 28,
		"base_tempo": 40,
		"base_xp": 15,
		"sprite": "res://assets/interface/sour_bottle.png",
	},
	"1": {
		"id": 1,
		"monster_name": "Treey",
		"base_attack": 55,
		"base_health": 90,
		"base_defense": 75,
		"base_tempo": 30,
		"base_xp": 5,
		"sprite": "res://assets/interface/massive_crisp_cabbage.png"
		#"sprite": "res://assets/interface/tile_0026.png",
	}
}

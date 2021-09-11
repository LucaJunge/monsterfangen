extends Node

# Global configuration

var encounterRate = 0.1
var nextMonster = null

var monsterDictionary = {
	"0": {
		"id": 0,
		"monster_name": "Qualli",
		"base_attack": 50,
		"base_health": 60,
		"base_defense": 28,
		"base_tempo": 40,
		"base_xp": 15,
		"sprite": "res://assets/interface/tile_0025.png",
	},
	"1": {
		"id": 1,
		"monster_name": "Baumi",
		"base_attack": 55,
		"base_health": 80,
		"base_defense": 53,
		"base_tempo": 30,
		"base_xp": 5,
		"sprite": "res://assets/interface/tile_0026.png",
	}
}

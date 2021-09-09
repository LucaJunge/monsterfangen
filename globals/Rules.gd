extends Node

# Global configuration

var encounterRate = 0.1
var nextMonster = null

var monsterDictionary = {
	"0": {
		"id": 0,
		"monster_name": "Qualli",
		"base_attack": 5,
		"base_health": 30,
		"sprite": "res://assets/interface/tile_0025.png",
	},
	"1": {
		"id": 1,
		"monster_name": "Baumi",
		"base_attack": 6,
		"base_health": 35,
		"sprite": "res://assets/interface/tile_0026.png",
	}
}

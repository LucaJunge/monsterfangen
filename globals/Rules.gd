extends Node

# Global configuration
var savegame_filename = "" # empty signals the SceneManager that no game shall be loaded

var encounterRate = 0.1
var nextMonster = null

var monsterDictionary = {
	"0": {
		"id": 0,
		"name": "Qualli",
		"baseAttack": 5,
		"baseHealth": 30,
		"sprite": "res://assets/interface/tile_0025.png",
	},
	"1": {
		"id": 1,
		"name": "Baumi",
		"baseAttack": 6,
		"baseHealth": 35,
		"sprite": "res://assets/interface/tile_0026.png",
	}
}

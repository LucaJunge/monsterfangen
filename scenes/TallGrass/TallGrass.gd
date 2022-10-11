extends Node2D

## The minimum level monsters can have in this tall grass
export (int, 1, 100) var level_range_min := 4

## The maximum level monsters can have in this tall grass
export (int, 1, 100) var level_range_max := 6

## The possibility of every triggering that a monster appears
export (float, 0.0, 1.0) var encounterRate := 0.09

export (Array, Resource) var available_monsters := []

onready var encounter_overlay := preload("res://scenes/EncounterScenes/EncounterMonsterSingle/EncounterMonsterSingle.tscn")

onready var encounter_music := preload("res://assets/music/fight_by_magic_spark.mp3")

onready var anim_player = $AnimationPlayer

func _ready():
	if(level_range_min > level_range_max or level_range_max < level_range_min):
		push_warning("Warning: TallGrass has a wrong level_range! Setting max to min." )
		level_range_max = level_range_min

func _on_Area2D_body_entered(_body):
	anim_player.play("Step")
	var randomNumber = rand_range(0.0, 1.0)
	
	# if the grass should trigger an encounter
	if randomNumber < encounterRate:
		
		# create a new monster based on the available levels/monsters
		var monster = _get_monster()
		
		# get the specific encounter scene
		var encounter_scene = encounter_overlay.instance()
		
		# prepare the encounter with all needed resources
		_body.prepare_encounter(monster, encounter_scene, encounter_music)

		
func _get_monster() -> Monster:
	var monster_resource = available_monsters[randi() % available_monsters.size()]
	var random_level = int(round(rand_range(level_range_min, level_range_max)))
	var monster = Monster.new(monster_resource.unique_id, {}, random_level)
	return monster

extends Node2D

## The minimum level monsters can have in this tall grass
export (int, 1, 100) var level_range_min := 1

## The maximum level monsters can have in this tall grass
export (int, 1, 100) var level_range_max := 5

## The possibility of every triggering that a monster appears
export (float, 0.0, 1.0) var encounterRate := 0.1

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
		print("encounter")
		SceneTransition.debug_animation("foliage")
		

extends Node2D

export (String, FILE) var encounterScene = ""

onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():

	pass


func _on_Area2D_body_entered(body):
	var randomNumber = rand_range(0.0, 1.0)
	anim_player.play("Step")
	
	if randomNumber < Rules.encounterRate:
		PlayerData.playerPosition = body.position
		body.will_encounter = true

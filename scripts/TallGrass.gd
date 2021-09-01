extends Node2D

export (String, FILE) var encounterScene = ""

onready var anim_player = $AnimationPlayer

const grass_overlay_texture = preload("res://assets/tilemap_packed.png")
var grass_overlay: TextureRect = null
var player_inside: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#randomize()
	pass


func player_exiting_grass():
	player_inside = false
	if is_instance_valid(grass_overlay):
		grass_overlay.queue_free()
	
func player_entering_grass():
	if player_inside == true:
			
		grass_overlay = TextureRect.new()
		grass_overlay.texture = grass_overlay_texture
		grass_overlay.rect_position = position
		get_tree().current_scene.add_child(grass_overlay)

func _on_Area2D_body_entered(body):
	player_inside = true
	var randomNumber = rand_range(0.0, 1.0)
	print(randomNumber)
	if randomNumber < Rules.encounterRate:
		body.get_node("Camera2D").clear_current()
		body.stop_input = true
		triggerEncounter()
	anim_player.play("Step")

func triggerEncounter():
	var enemyMonster = Monster.new(Rules.monsterDictionary["0"])
	Rules.nextMonster = enemyMonster
	print("NextMonster", Rules.nextMonster)
	#print("Monster Encounter"+ String(randomNumber))
	get_node(NodePath("/root/SceneManager")).transition_to_scene("res://scenes/Encounter.tscn")

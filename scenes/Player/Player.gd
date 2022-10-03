extends KinematicBody2D

signal player_moving_signal
signal player_stopped_signal
signal player_has_entered_signal

export var walk_speed = 5.0
const TILE_SIZE = 16

# Resources of the player
var player: Player setget set_player
var party: Party setget set_party

onready var animation_tree = $AnimationTree
onready var anim_state = animation_tree.get("parameters/playback")
onready var blocking_ray = $BlockingRayCast2D
onready var scene_transition_ray = $SceneTransitionRayCast2D
onready var interaction_ray = $InteractionRayCast2D

# The F button
onready var interact_button := get_node("/root/Game/UILayer/UI/%InteractionButton")

onready var interaction_ray_line2d = $InteractionRayLine2D

# the animation states the player can be in
enum PlayerState { IDLE, TURNING, WALKING }
# the facing directions the player can be in
enum FacingDirection {LEFT = 0, RIGHT = 1, UP = 2, DOWN = 3 }

# default values
var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN
var initial_position: Vector2 = Vector2(0, 0)
var input_direction: Vector2 = Vector2(0, 0)
var stop_input: bool = false
var moving = false
var will_encounter: bool = false
var encounter_level_range = {"min": 1, "max": 5}

onready var playerName = "PlayerData.playerName"

var percent_moved_to_next_tile = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	
	# set player position on load
	position = Vector2(0, 0)
	
	initial_position = position
	
	set_spawn_direction(Vector2(0, 1))
	
	# load all possible sounds
	# BUG: also currently imports the .import metadata files...
	#load_sounds()
	
	# connect the interaction button to interact method
	interact_button.connect("interact_pressed", self, "interact")
	
	# Set camera position on load
	$Camera2D.position = Vector2(0, 0)

func set_player(new_player: Player) -> void:
	player = new_player

func set_party(new_party: Party) -> void:
	party = new_party

func _physics_process(delta):
	# no physics need to be calculated when the player is currently turning, so just return
	if player_state == PlayerState.TURNING or stop_input:
		return
		
	# if the player is not moving, try to process the possible input
	elif not moving:
		get_input_direction()
		
		# change the animation states to represent the current direction
		if input_direction != Vector2.ZERO:
			#set_spawn_direction(input_direction) would be shorter
			animation_tree.set("parameters/Idle/blend_position", input_direction)
			animation_tree.set("parameters/Walk/blend_position", input_direction)
			animation_tree.set("parameters/Turn/blend_position", input_direction)
			
			# evaluates the input direction and checks if it differs from current direction
			if need_to_turn():
				player_state = PlayerState.TURNING
				anim_state.travel("Turn")
			else:
				initial_position = position
				moving = true
				
		# player did not move, do nothing
		else:
			anim_state.travel("Idle")
	
	# if we are moving (which means input direction is not 0), play the walk
	# animation and move
	elif input_direction != Vector2.ZERO:
		anim_state.travel("Walk")
		move(delta)
		
	# the player is not moving
	else:
		anim_state.travel("Idle")
		moving = false
		
func get_input_direction():
	# move in one direction, only if the other one is 0
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		
func need_to_turn():
	var new_facing_direction
	if input_direction.x < 0:
		new_facing_direction = FacingDirection.LEFT
	elif input_direction.x > 0:
		new_facing_direction = FacingDirection.RIGHT
	elif input_direction.y < 0:
		new_facing_direction = FacingDirection.UP
	elif input_direction.y > 0:
		new_facing_direction = FacingDirection.DOWN
	
	# facing direction has changed
	if facing_direction != new_facing_direction:
		# set new facing direction and return "needs to turn"
		facing_direction = new_facing_direction
		return true
	
	# facing direction is the same
	return false
	
func finished_turning():
	player_state = PlayerState.IDLE
	
func interact():
	var interactable = null
	# get the current facing direction
	#print("Facing Direction: " + str(facing_direction))
	match int(facing_direction):
		0: #left
			interaction_ray.cast_to = Vector2(-8, 0)
			interaction_ray.force_raycast_update()
			interactable = interaction_ray.get_collider()
		1: #right
			interaction_ray.cast_to = Vector2(8, 0)
			interaction_ray.force_raycast_update()
			interactable = interaction_ray.get_collider()
		2: #up
			interaction_ray.cast_to = Vector2(0, -8)
			interaction_ray.force_raycast_update()
			interactable = interaction_ray.get_collider()
		3: #down
			interaction_ray.cast_to = Vector2(0, 8)
			interaction_ray.force_raycast_update()
			interactable = interaction_ray.get_collider()
	
	interaction_ray_line2d.set_point_position(1, interaction_ray.cast_to + interaction_ray.cast_to)
	#print(interaction_ray.cast_to)
	if interactable and interactable.has_method("interact"):
		#stop_input = true
		interactable.interact(self)
		# how to enable input again? ;(
	
func move(delta):
	
	# cast the ray into half of the next block
	var desired_step: Vector2 = input_direction * TILE_SIZE / 2
	
	# cast a ray to the half of the block in front
	blocking_ray.cast_to = desired_step
	blocking_ray.force_raycast_update()
	
	scene_transition_ray.cast_to = desired_step
	scene_transition_ray.force_raycast_update()
	
	# first check if there is a scene transition in the next tile
	if scene_transition_ray.is_colliding():

		percent_moved_to_next_tile += walk_speed * delta
		
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			percent_moved_to_next_tile = 0.0
			stop_input = true;
			moving = false
			$Camera2D.clear_current()
			emit_signal("player_has_entered_signal")
			emit_signal("player_stopped_signal")
		else:
			# gradually interpolate the position until percent_moved_to_next_tile is 1.0
			position = initial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile)
	
	# if no collision is found, move
	elif !blocking_ray.is_colliding():
		if percent_moved_to_next_tile == 0:
			emit_signal("player_moving_signal")
				
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			percent_moved_to_next_tile = 0.0
			moving = false
			emit_signal("player_stopped_signal")
			if will_encounter:
				triggerEncounter(0)

		else:
			# gradually interpolate the position until percent_moved_to_next_tile is 1.0
			position = initial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile)
	else:
		moving = false

func triggerEncounter(_monster_to_spawn: int = 0):
	anim_state.travel("Idle")
	$Camera2D.clear_current()
	stop_input = true
	will_encounter = false
	#var enemy_monster := MonsterDatabase.get_monster_data("treey")
	#print(enemy_monster)
	#var enemy_monster = Monster.new(Rules.monsterDictionary[str(monster_to_spawn)])
	#var enemy_level = ceil(rand_range(encounter_level_range.min, encounter_level_range.max-0.1))
	#enemy_monster.set_level(enemy_level)
	#print(enemy_monster.level)
	#Rules.nextMonster = enemy_monster
	#PlayerData.playerPosition = position
	#PlayerData.playerDirection = input_direction
	#get_node(NodePath("/root/SceneManager")).transition_to_scene("res://scenes/Encounter/Encounter.tscn", false)
	
func set_spawn_direction(direction: Vector2):
	animation_tree.set("parameters/Idle/blend_position", direction)
	animation_tree.set("parameters/Walk/blend_position", direction)
	animation_tree.set("parameters/Turn/blend_position", direction)

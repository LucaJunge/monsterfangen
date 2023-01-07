extends KinematicBody2D

signal player_moving_signal
signal player_stopped_signal
signal player_has_entered_signal

# general
export var walk_speed = 5.0
const TILE_SIZE = 16
var stop_moving: bool = false

# Resources of the player
var stats: Stats setget set_stats
var party: Party setget set_party

# Encounter related
var enemy_monster : Monster = null
var encounter_scene: Node = null
var encounter_music: AudioStream = null

# 
onready var animation_tree = $AnimationTree
onready var anim_state = animation_tree.get("parameters/playback")
onready var blocking_ray = $BlockingRayCast2D
onready var scene_transition_ray = $SceneTransitionRayCast2D
onready var interaction_ray = $InteractionRayCast2D

# The interact button
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
var moving: bool = false
var will_encounter: bool = false

onready var playerName = "PlayerData.playerName"

var percent_moved_to_next_tile = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	
	# set player position on load
	#position = Vector2(0, 0)
	
	initial_position = position
	
	set_spawn_direction(Vector2(0, 1))
	
	# connect the interaction button to interact method
	interact_button.connect("interact_pressed", self, "interact")
	
	# Set camera position on load
	$Camera2D.position = Vector2(0, 0)

func set_stats(new_stats: Stats) -> void:
	stats = new_stats

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
	
	# if the player should not move, return immediately
	if stop_moving:
		anim_state.travel("Idle")
		return
	
	# get the position where to scan for a collision
	var desired_step: Vector2 = input_direction * TILE_SIZE / 2
	
	# cast a ray to the half of the block in front for moving
	blocking_ray.cast_to = desired_step
	blocking_ray.force_raycast_update()
	
		# cast a ray to the half of the block in front for entering another scene
	scene_transition_ray.cast_to = desired_step
	scene_transition_ray.force_raycast_update()
	
	# first check if there is a scene transition in the next tile
	if scene_transition_ray.is_colliding():
		percent_moved_to_next_tile += walk_speed * delta
		
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			percent_moved_to_next_tile = 0.0
			moving = false
			stop_moving = true
			stop_input = true
			
			$Camera2D.clear_current()
			var next_scene = scene_transition_ray.get_collider().next_scene_path

			var collider = scene_transition_ray.get_collider()
			print_debug(collider.exit_position)
			SceneTransition.change_scene(next_scene, "fade", collider.exit_position)
				
		else:
			# gradually interpolate the position until percent_moved_to_next_tile is 1.0
			position = initial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile)
	
	# if no collision is found, move
	elif !blocking_ray.is_colliding():
		
		if percent_moved_to_next_tile == 0:
			# player starts to move
			emit_signal("player_moving_signal")
		
		# advance the player a delta amount into the next tile
		percent_moved_to_next_tile += walk_speed * delta
		
		# reset the percentage if the player reached the new tile
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			percent_moved_to_next_tile = 0.0
			moving = false
			
			# player finished the movement to the next tile
			emit_signal("player_stopped_signal")
			
			# trigger an encounter, if it should happen
			if will_encounter:
				#print_debug("ENCOUNTER")
				encounter()

		else:
			# gradually interpolate the position until percent_moved_to_next_tile is 1.0
			position = initial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile)
	else:
		moving = false

func prepare_encounter(_enemy_monster: Monster, _encounter_scene: Node, _encounter_music: AudioStream):
	will_encounter = true
	enemy_monster = _enemy_monster
	encounter_scene = _encounter_scene
	encounter_music = _encounter_music
	pass
	
func encounter():
	stop_moving = true
	AudioManager.stop()
	AudioManager.play_loop(encounter_music)
	
	get_node("/root/").add_child(encounter_scene)
	encounter_scene.init(enemy_monster, party.members[0], party)
	
	# TODO: Grass Animation should animate the anchors, not the rect_position
	SceneTransition.change_overlay(encounter_scene, "foliage")

func disable_movement():
	stop_moving = true

func enable_movement():
	# this is needed, because otherwise the player will
	# move after exiting from an encounter
	input_direction = Vector2(0, 0)
	
	# activate movement again
	stop_moving = false
	will_encounter = false
	
func set_spawn_direction(direction: Vector2):
	animation_tree.set("parameters/Idle/blend_position", direction)
	animation_tree.set("parameters/Walk/blend_position", direction)
	animation_tree.set("parameters/Turn/blend_position", direction)

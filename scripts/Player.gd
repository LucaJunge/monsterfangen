extends KinematicBody2D

signal player_moving_signal
signal player_stopped_signal
signal player_has_entered_signal
signal player_triggered_encounter_signal

export var walk_speed = 5.0
const TILE_SIZE = 16

onready var anim_tree = $AnimationTree
onready var anim_state = anim_tree.get("parameters/playback")
onready var ray = $BlockingRayCast2D
onready var scene_transition_ray = $SceneTransitionRayCast2D

enum PlayerState { IDLE, TURNING, WALKING }
enum FacingDirection {LEFT, RIGHT, UP, DOWN }

var player_state = PlayerState.IDLE
var facing_direction = FacingDirection.DOWN

var stop_input: bool = false
var initial_position = Vector2(0, 0)
var input_direction = Vector2(0, 0)
var is_moving = false
var percent_moved_to_next_tile = 0.0

var partyMonsters = []

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_tree.active = true
	initial_position = position
	
	# Set cameras position on load
	$Camera2D.position = position
	PlayerData.playerParty.append(Monster.new(Rules.monsterDictionary["1"]))
	#print(PlayerData.playerParty)


func _physics_process(delta):
	# no physics need to be calculated when the player is turning,
	# so just return
	
	#print(int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
	if player_state == PlayerState.TURNING or stop_input:
		return
	# if the player is not moving, try to process the possible input
	elif is_moving == false:
		process_player_input()
	
	# if we are moving (which means input direction is not 0), play the walk
	# animation and move
	elif input_direction != Vector2.ZERO:
		anim_state.travel("Walk")
		move(delta)
		
	# the player is not moving
	else:
		anim_state.travel("Idle")
		is_moving = false
		
func process_player_input():
	# move in one direction, only if the other one is 0
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		
	# change the animation states to represent the current direction
	if input_direction != Vector2.ZERO:
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Walk/blend_position", input_direction)
		anim_tree.set("parameters/Turn/blend_position", input_direction)
		
		if need_to_turn():
			player_state = PlayerState.TURNING
			anim_state.travel("Turn")
		else:
			initial_position = position
			is_moving = true
	else:
		anim_state.travel("Idle")
		
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
		
	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true
		
	facing_direction = new_facing_direction
	return false
	
func finished_turning():
	player_state = PlayerState.IDLE
	
func move(delta):
	
	# cast into half of the next block
	var desired_step: Vector2 = input_direction * TILE_SIZE / 2
	
	# cast a ray to the half of the block in front
	ray.cast_to = desired_step
	ray.force_raycast_update()
	
	scene_transition_ray.cast_to = desired_step
	scene_transition_ray.force_raycast_update()
	
	if scene_transition_ray.is_colliding():
		emit_signal("player_has_entered_signal")
		$Camera2D.clear_current()
		stop_input = true
		is_moving = false
		emit_signal("player_stopped_signal")
	# only move if no collising is found
	
	elif !ray.is_colliding():
		if percent_moved_to_next_tile == 0:
			emit_signal("player_moving_signal")
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + (TILE_SIZE * input_direction)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			emit_signal("player_stopped_signal")
		else:
			position = initial_position + (TILE_SIZE * input_direction * percent_moved_to_next_tile)
	else:
		is_moving = false

func save():
	var save_dict = {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"pos_x": position.x, # Vector 2 is not supported by JSON
		"pos_y": position.y
	}
	return save_dict

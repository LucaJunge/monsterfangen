extends Tween

onready var new_game = get_node("%StartNewGameButton")
onready var load_game = get_node("%LoadGameButton")
onready var options = get_node("%OptionsButton")
onready var exit = get_node("%ExitButton")

var delay := 0.33
var delay_add := 0.07
var duration := 0.4

func _ready() -> void:
	new_game.rect_position.x = -100
	interpolate_property(new_game, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, delay)
	#interpolate_property(new_game, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, delay)
	delay += delay_add
	interpolate_property(load_game, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, delay)
	delay += delay_add
	interpolate_property(options, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, delay)
	delay += delay_add
	interpolate_property(exit, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, delay)
	start()

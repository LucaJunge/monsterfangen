extends VBoxContainer

signal button_pressed

var disabled setget _disabled_set

onready var click = load("res://assets/sounds/click.wav")
onready var button = get_node("%Button")

export var label : String = "NO_LABEL"
export (String, FILE, "*.png,*.svg") var icon_path = "res://assets/ui/icons/player_icon.png"
export (Color) var icon_color = Color(0, 1, 0)

func _ready() -> void:
	$VBoxContainer/Label.text = label
	$CenterContainer/Icon.texture = load(icon_path)
	$CenterContainer/Icon.modulate = icon_color

func _on_Button_pressed():
	AudioManager.play(click)
	$AnimationPlayer.play("click")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("button_pressed")

func _disabled_set(value: bool):
	button.disabled = value

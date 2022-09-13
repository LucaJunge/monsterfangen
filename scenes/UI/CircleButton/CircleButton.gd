extends VBoxContainer

signal button_pressed

export var label : String = "NO_LABEL"
export (String, FILE, "*.png,*.svg") var icon_path = "res://assets/ui/icons/player_icon.png"
export (Color) var icon_color = Color(0, 1, 0)

func _ready() -> void:
	$VBoxContainer/Label.text = label
	$CenterContainer/Icon.texture = load(icon_path)
	$CenterContainer/Icon.modulate = icon_color

func _on_Button_pressed():
	$AnimationPlayer.play("click")
	yield($AnimationPlayer, "animation_finished")
	emit_signal("button_pressed")

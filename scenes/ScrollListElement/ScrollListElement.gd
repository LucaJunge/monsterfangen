extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var last_touch_position = Vector2(0, 0)
var is_pressed = false
var exited = false
var was_clicked = false
var color = Color(0, 0, 0)
var click_color = Color(0, 0, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	color = self.get("custom_styles/panel/StyleBoxTexture").bg_color
	click_color = color.darkened(0.3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ScrollListElement_gui_input(event):
	if event is InputEventScreenTouch:
		
		is_pressed = event.pressed
		if last_touch_position == event.position and not is_pressed:
			_on_click()
		
		last_touch_position = event.position
	
	if event is InputEventScreenDrag:
		last_touch_position = event.position

func _on_click():
	if !was_clicked:
		self.get("custom_styles/panel/StyleBoxTexture").bg_color = click_color
		was_clicked = !was_clicked
	else:
		self.get("custom_styles/panel/StyleBoxTexture").bg_color = color
		was_clicked = !was_clicked
		
	print("clicked")

extends Control

var list_elems = 200
var type_colors = [
	Color("48D0B0"),
	Color("FB6C6C"),
	Color("76BDFE"),
	Color("FFD86F")
]
var types = [
	"ghostly",
	"spritiual",
	"dark",
	"firey",
	"nature",
	"psycho",
	"dreamy"
]
onready var list_container = $VBoxContainer/ScrollContainer/MarginContainer/GridContainer
	onready var scroll_list_element = preload("res://scenes/ScrollListElement/ScrollListElement.tscn")
onready var scroll_bar = $VBoxContainer/ScrollContainer.get_v_scrollbar()

var last_position = Vector2(0, 0)
func _ready():
	
	for elem in list_elems:
		populate_elem()

func _on_ScrollContainer_scroll_started():
	pass # Replace with function body.

func on_scrollbar_change(event):
	pass

func populate_elem():
	var list_elem = scroll_list_element.instance()
	list_elem.get("custom_styles/panel/StyleBoxTexture").bg_color = type_colors[randi() % type_colors.size()]
	if(randi() % 2 > 0):
		list_elem.get_node("VBoxContainer/VBoxContainer/type_2").modulate = Color(0.0, 0.0, 0.0, 0.0)
		list_elem.get_node("VBoxContainer/VBoxContainer/type_1").text = types[randi() % types.size()]
	else:
		var type_1 = randi() % types.size()
		var type_2 = randi() % types.size()
		
		while type_2 == type_1:
			type_1 = randi() % types.size()
			
		list_elem.get_node("VBoxContainer/VBoxContainer/type_1").text = types[type_1]
		list_elem.get_node("VBoxContainer/VBoxContainer/type_2").text = types[type_2]
	list_container.add_child(list_elem)

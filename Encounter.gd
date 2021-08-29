extends Control

var screenSize = null
onready var screenSizeText = $CanvasLayer/ScreenSize
onready var backgroundImage = $CanvasLayer/BackgroundImage

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport().size #OS.get_screen_size() # use this for actual monitor size
	get_tree().get_root().connect("size_changed", self, "adaptSprites")
	print(screenSize[0])
	adaptSprites()

func adaptSprites():
	screenSizeText.set_bbcode(String(screenSize))
	print(backgroundImage.rect_size)
	backgroundImage.rect_size = screenSize
	print(backgroundImage.rect_size)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Node
class_name Pokemon, "res://assets/interface/pokemon.png"

#var variable = value setget setterfunc, getterfunc

var baseAttack = 5

func _init(attackValue):
	baseAttack = attackValue
	print("New Pokemon created with " + String(baseAttack) + " baseAttack")

func attack():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

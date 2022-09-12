extends Area2D

export (String, FILE,  "*.tres,*.res") var next_scene_path = ""

func _ready() -> void:
	pass


func _on_Entrance_body_entered(body):
	print(body)
	pass # Replace with function body.

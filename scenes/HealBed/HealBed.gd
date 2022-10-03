extends StaticBody2D

export (Resource) var dialog 

func interact(player: KinematicBody2D):
	print("interact")
	DialogManager.show_dialog(dialog)
	# heal the player
	print_debug(player)
	
	# heal every monster in party...
	for monster in player.party.members:
		monster.heal(10)
	

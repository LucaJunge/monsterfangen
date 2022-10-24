class_name Party
extends Resource

var max_members: int = 6
var members: Array = Array()

# adds (and overwrites!) a member at the specified position
func add_member(_position: String, monster: Monster) -> void:
	members.append(monster)

# appends a member to the next free space if available
func append_member(monster: Monster) -> void:
	if not is_full():
		members.append(monster)

# helper method to determine if the party is full
func is_full() -> bool:
	if len(members) >= 6:
		return true
	else:
		return false

# swaps the position of the two members
#func swap_member(first_monster: Monster, second_monster: Monster):
#	pass

# removes a member from the array and moves up the remaining monsters
#func remove_member()
#	pass

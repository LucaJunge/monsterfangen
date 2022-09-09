class_name Inventory
extends Resource

# Ideally, I would like to store an array of item resources here, but this is
# not well-supported in Godot 3. Once loaded back, the item resources would lose
# their type information. This is because GDScript does not support typed arrays in Godot 3.
#
# So instead, we use a plain dictionary with strings and numbers. Keys are the
# items' unique ids and values represent the owned amount.
#
# Note that dictionaries preserve their order in GDScript.
export var items := {}


func add_item(unique_id : String, amount := 1) -> void:
	if unique_id in items:
		items[unique_id] += amount
	else:
		items[unique_id] = amount
	emit_changed()
	
func get_amount(unique_id: String) -> int:
	if not unique_id in items:
		printerr("Trying to get the amount of item %s but it doesnt exist in the inventory" % unique_id)
		return -1
	return items[unique_id]
	
func remove_item(unique_id: String, amount := 1) -> void:
	if not unique_id in items:
		printerr("Trying to remove item %s but it doesnt exist in the inventory" % unique_id)
		return
	
	items[unique_id] -= amount
	
	if items[unique_id] <= 0:
		# warning-ignore:return_value_discarded
		items.erase(unique_id)
	emit_changed()

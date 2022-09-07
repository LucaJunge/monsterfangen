extends Resource
class_name Inventory

signal inventory_changed

export var _items = Array() setget set_items, get_items

func set_items(new_items):
	_items = new_items
	emit_signal("inventory_changed", self)
	
func get_items():
	return _items
	
func get_item(index):
	return _items[index]

func add_item(item_name, quantity):
	if quantity <= 0:
		print("Can't add a negative number of items")
		return
	
	# Find item in our database
	var item = ItemDatabase.get_item(item_name)
	if not item:
		print("Could not find item")
		return
		
	var remaining_quantity = quantity
	var max_stack_size = item.max_stack_size
	
	for i in range(_items.size()):
		if remaining_quantity == 0:
			break
			
		var inventory_item = _items[i]
		
		# 
		if inventory_item.item_reference.name != item.name:
			continue
			
		if inventory_item.quantity < max_stack_size:
			var original_quantity = inventory_item.quantity
			inventory_item.quantity = min(original_quantity + remaining_quantity, max_stack_size)
			remaining_quantity -= inventory_item.quantity - original_quantity
	
	emit_signal("inventory_changed", self)

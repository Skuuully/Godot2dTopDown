# ItemInventory
# Inventory to add items to
extends Node
class_name ItemInventory

# String to Item
var Items = []

func add(item) -> void:
	Items.push_back(item)
	item.do()

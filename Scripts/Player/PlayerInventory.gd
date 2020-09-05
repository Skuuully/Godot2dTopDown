extends Node

# String to Item
var Items = {}

func add(item) -> void:
	Items[item.id()] = item
	item.do()

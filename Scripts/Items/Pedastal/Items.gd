# Items
# Collection of all items
extends Node

var allItems = []
var tier1Items = []
var tier2Items = []
var tier3Items = []

func _ready():
	var reinforcedChamber:ItemReinforcedChamber = ItemReinforcedChamber.new()
	addToCollections(reinforcedChamber)

func addToCollections(item:Item) -> void:
	match item.tier:
		1:
			tier1Items.push_back(item)
		2:
			tier2Items.push_back(item)
		3:
			tier3Items.push_back(item)
	allItems.push_back(item)

func getRandomItem(tier) -> Item:
	var item = null
	match tier:
		1:
			item = getRandomItemFromArray(tier1Items)
		2:
			item = getRandomItemFromArray(tier2Items)
		3:
			item = getRandomItemFromArray(tier3Items)
	return item

func getRandomItemFromArray(array:Array) -> Item:
	var index = randi() % array.size()
	return array[index]

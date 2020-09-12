# PlayerInventory
# Inventory has multiple inventories to store different collections of things
extends Node

var itemInventory:ItemInventory setget , getItemInventory
var mapInventory:MapInventory setget , getMapInventory

func _init() -> void:
	itemInventory = ItemInventory.new()
	add_child(itemInventory)
	mapInventory = MapInventory.new()
	add_child(mapInventory)

func addItem(item) -> void:
	itemInventory.add(item)

func addMap(map) -> void:
	mapInventory.add(map)

func getItemInventory() -> ItemInventory:
	return itemInventory

func getMapInventory() -> MapInventory:
	return mapInventory

# MapInventory
# Stores all the business logic for the player storing maps in an inventory
extends Node
class_name MapInventory

signal mapAdded(map)
signal mapRemoved(map)

var inventorySize:int = 7
var maps:Array = [] setget setMaps, getMaps

func _ready() -> void:
	# Init with some rooms to begin with
	var mapData = MapData.new(
		load("res://Prefabs/Rooms/BasicRoom.tscn"), 1, MapData.mapType.ENEMY)
	addMap(mapData)
	mapData = MapData.new(
		load("res://Prefabs/Rooms/LootRoom.tscn"), 1, MapData.mapType.LOOT)
	addMap(mapData)

func addMap(map:MapData) -> void:
	if canAddMap():
		assert(map is MapData)
		maps.push_back(map)
		emit_signal("mapAdded", map)

func canAddMap() -> bool:
	return maps.size() < inventorySize

func removeMap(map:MapData) -> void:
	maps.remove(maps.find(map))
	emit_signal("mapRemoved", map)

func setMaps(_inMaps) -> void:
	pass

func getMaps() -> Array:
	return maps

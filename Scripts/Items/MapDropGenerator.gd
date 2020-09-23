extends Node2D
class_name MapDropGenerator

var maps = []
var mapItem = load("res://Prefabs/MapItem.tscn")
var tier:int setget setTier

func setTier(inTier:int) -> void:
	tier = inTier

func getMaps() -> Array:
	generateMaps()
	return maps

func generateMaps() -> void:
	if requireCriticalRoom():
		addCriticalRoom()
	
	if shouldAddLootRoom():
		addLootRoom()
	
	if shouldAddEnemyRoom():
		addEnemyRoom()

func requireCriticalRoom() -> bool:
	return !PlayerInventory.getMapInventory().hasEnemyRoom()

func addCriticalRoom() -> void:
	var instance = mapItem.instance()
	instance.mapData = MapData.new(
		load("res://Prefabs/Rooms/EnemyRoom.tscn"), 1, MapData.mapType.ENEMY)
	maps.push_back(instance)

func shouldAddLootRoom() -> bool:
	var requiredCheck = 5 * tier
	return requiredCheck > randi() % 101

func addLootRoom() -> void:
	var instance = mapItem.instance()
	var lootRoomTier:int = randi() % (tier + 1) + 1
	instance.mapData = MapData.new(
		load("res://Prefabs/Rooms/LootRoom.tscn"), lootRoomTier, MapData.mapType.LOOT)
	maps.push_back(instance)

func shouldAddEnemyRoom() -> bool:
	var requiredCheck = 20 * tier
	return requiredCheck > randi() % 101

func addEnemyRoom() -> void:
	var instance = mapItem.instance()
	var roomTier:int = randi() % (tier + 1) + 1
	instance.mapData = MapData.new(
		load("res://Prefabs/Rooms/EnemyRoom.tscn"), roomTier, MapData.mapType.ENEMY)
	maps.push_back(instance)

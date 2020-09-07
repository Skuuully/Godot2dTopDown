# LootSpawn
# Responsible for spawning additional rooms for the players map inventory
# as well as any extra possible loot - health, upgrades, etc.
extends Node2D

export(RectangleShape2D) var area
var rng = RandomNumberGenerator.new()
var lootSpawned:bool = false

var mapItem = load("res://Prefabs/MapItem.tscn")
var basicEnemy = load("res://Prefabs/Rooms/BasicRoom.tscn")
var basicLoot = load("res://Prefabs/Rooms/LootRoom.tscn")

func spawnLoot() -> void:
	if !lootSpawned:
		lootSpawned = true
		spawnMaps()

func spawnMaps() -> void:
	var numToSpawn = (rng.randi() % 2) + 1
	for i in numToSpawn:
		spawnMap()

func spawnMap() -> void:
	var mapData
	var rand:int = rng.randi() % 10 + 1
	if rand > 7:
		mapData = MapData.new(basicEnemy, 0, MapData.mapType.ENEMY)
	else:
		mapData = MapData.new(basicLoot, 0, MapData.mapType.LOOT)
	var instance = mapItem.instance()
	instance.mapData = mapData
	instance.position = position
	instance.scale = Vector2(0.3, 0.3)
	add_child(instance)

func spawnItem() -> void:
	
	pass

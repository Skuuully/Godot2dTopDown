# LootSpawn
# Responsible for spawning additional rooms for the players map inventory
# as well as any extra possible loot - health, upgrades, etc.
extends Node2D
class_name LootSpawn

export(RectangleShape2D) var area

onready var mapDropGen = $MapDropGenerator

var mapItem = load("res://Prefabs/MapItem.tscn")
var basicEnemy = load("res://Prefabs/Rooms/EnemyRoom.tscn")
var basicLoot = load("res://Prefabs/Rooms/LootRoom.tscn")

var spacing:Vector2 = Vector2(20, 20)
var topLeftPosition:Vector2 = position - spacing
var currentRowColumn = Vector2(0,0)
var rows:int = 3

var lootSpawned:bool = false
var tier:int = 1

func _ready() -> void:
	var spacingMultiple = (0.5*rows) - 0.5
	topLeftPosition = position - (spacingMultiple*spacing)

func spawnLoot(inTier:int) -> void:
	tier = inTier
	mapDropGen.setTier(tier)
	if !lootSpawned:
		lootSpawned = true
		spawnMaps()

func spawnMaps() -> void:
	var maps = mapDropGen.getMaps()
	for map in maps:
		map.scale = Vector2(0.3, 0.3)
		spawnItem(map)

func spawnItem(spawnee) -> void:
	currentRowColumn.x += 1
	if currentRowColumn.x == rows:
		currentRowColumn.x = 0
		currentRowColumn.y += 1
	
	var spawnPos = topLeftPosition + (spacing * currentRowColumn)
	
	spawnee.position = spawnPos
	call_deferred("add_child", spawnee)

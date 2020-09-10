# MapData
# Stores info about a map that can then be used in other contexts
extends Node
class_name MapData

enum mapType {EMPTY, ENEMY, LOOT}

export(PackedScene) var scene = null
export(Texture) var texture = null
export(Texture) var borderTexture = null
export(Color) var borderColour = Color(1.0, 1.0, 1.0, 1.0)
export(int) var tier = 0
export(mapType) var type

var emptyIcon = null
var enemyIcon = preload("res://Sprites/UI/MapIcons/EnemyRoomIcon64.png")
var lootIcon = preload("res://Sprites/UI/MapIcons/LootIcon64.png")

var tierBorders = [preload("res://Sprites/UI/MapIcons/Tier1Border.png"),
					preload("res://Sprites/UI/MapIcons/Tier2Border.png"),
					preload("res://Sprites/UI/MapIcons/Tier3Border.png")]

func _init(inScene:PackedScene, inTier:int, inType) -> void:
	scene = inScene
	tier = inTier
	type = inType
	setupTexture()

func setupTexture() -> void:
	match type:
		mapType.EMPTY:
			texture = emptyIcon
			borderColour = Color(1.0, 1.0, 1.0, 1.0)
		mapType.ENEMY:
			texture = enemyIcon
			borderColour = Color(1.0, 0.0, 0.0, 1.0)
		mapType.LOOT:
			texture = lootIcon
			borderColour = Color(0.8, 0.8, 0.2, 1.0)
	
	# tiers are 1, 2, 3
	assert(tier < 4 && tier > 0)
	match tier:
		1:
			borderTexture = tierBorders[0]
		2:
			borderTexture = tierBorders[1]
		3:
			borderTexture = tierBorders[2]

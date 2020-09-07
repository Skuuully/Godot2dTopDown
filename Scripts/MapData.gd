# MapData
# Stores info about a map that can then be used in other contexts
extends Node
class_name MapData

enum mapType {EMPTY, ENEMY, LOOT}

export(PackedScene) var scene = null
export(Texture) var texture = null
export(int) var tier = 0
export(mapType) var type

var icon = preload("res://Sprites/icon.png")

func _init(inScene:PackedScene, inTier:int, inType) -> void:
	scene = inScene
	tier = inTier
	type = inType
	setupTexture()

func setupTexture() -> void:
	match type:
		mapType.EMPTY:
			texture = icon
		mapType.ENEMY:
			texture = icon
		mapType.LOOT:
			texture = icon

# Class to cache globally available nodes
extends Node

# Map of string for node name to node
var nodeCache = {}

func _ready() -> void:
	nodeCache["World"] = get_tree().get_root().find_node("World", false, false)

func getNode(nodeName:String) -> Node:
	var node = nodeCache.get(nodeName)
	
	if node == null:
		var world:Node = nodeCache["World"]
		node = world.find_node(nodeName, true, false)
		if node == null:
			printerr("Attempting to find node: " + nodeName + " but failed")
		else:
			nodeCache[nodeName] = node
	
	return node

func getWorldMap() -> WorldMap:
	return getNode("WorldMap") as WorldMap

func getPlayer() -> Player:
	return getNode("Player") as Player

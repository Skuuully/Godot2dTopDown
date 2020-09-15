extends GridContainer
class_name MapContainer

var mapElement = preload("res://Prefabs/MapElement.tscn")
var mapElements = {}
var currentRoom:Vector2 = Vector2(0, 0)

func initialiseGrid(row:int, col:int) -> void:
	# first empty all children
	for child in get_children():
		remove_child(child)

	columns = col
	# add as many elements as specified creating a map of vector2 to map elements
	for r in row:
		for c in col:
			var instance = mapElement.instance()
			var treeNodeName = "MapElement[" + str(r) + ", " + str(c) + "]";
			add_child(instance, true)
			instance.name = treeNodeName
			instance.gridPosition = Vector2(r, c)
			mapElements[Vector2(r, c)] = instance

func roomAdded(position:Vector2, mapData) -> void:
	var element = mapElements.get(position)
	if element is MapElement:
		element.mapData = mapData
		(element as MapElement).changeState(MapElement.State.PLACED)

func playerEnteredRoom(roomPosition:Vector2) -> void:
	mapElements[currentRoom].setContainsPlayer(false)
	mapElements[roomPosition].setContainsPlayer(true)
	currentRoom = roomPosition

func clearCurrentRoomIcon() -> void:
	mapElements[currentRoom].clearIcon()

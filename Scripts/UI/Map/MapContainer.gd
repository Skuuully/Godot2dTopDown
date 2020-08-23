extends GridContainer
class_name MapContainer

var mapElement = preload("res://Prefabs/MapElement.tscn")
var mapElements = {}

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
			mapElements[Vector2(r, c)] = instance

func roomAdded(position:Vector2, state) -> void:
	var element = mapElements.get(position)
	if element is MapElement:
		(element as MapElement).changeState(state)

# Gets the position of the node as (row, column), returns (-1, -1) if the node
# is not in the grid
func getPosition(node:Node) -> Vector2:
	if (self.get_node(node.name) != null):
		var i:int = -1
		for child in self.get_children():
			i += 1
			if node == child:
				var col = floor(i as float / self.columns as float)
				var row = i % self.columns
				return Vector2(row, col)
	
	return Vector2(-1, -1)

func playerEnteredRoom(roomPosition:Vector2) -> void:
	var i:int = -1
	for child in get_children():
		i += 1
		var col = floor(i as float / self.columns as float)
		var row = i % self.columns
		if Vector2(row, col) == roomPosition:
			child.setContainsPlayer(true)
		else:
			child.setContainsPlayer(false)

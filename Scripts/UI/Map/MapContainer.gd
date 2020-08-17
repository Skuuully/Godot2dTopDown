extends GridContainer
class_name MapContainer

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

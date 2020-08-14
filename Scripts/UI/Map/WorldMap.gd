extends Node2D
class_name WorldMap

signal roomAdded(room)

export var rows:int
export var cols:int
export var xSpace:int
export var ySpace:int

var basicRoom = preload("res://Prefabs/Rooms/BasicRoom.tscn")

# Map of vector2(row,col) to Position2D(World space for rooms)
var positionMap = {}

# Map of vector2(row, col) to rooms - tracks which rooms have been placed
var placedMap = {}

func _ready():
	createGrid()
	connectToGUI()

func createGrid() -> void:
	for row in rows:
		for col in cols:
			var pos = Position2D.new()
			pos.position.x = row * xSpace
			pos.position.y = col * ySpace
			self.add_child(pos)
			positionMap[Vector2(row, col)] = pos
			placedMap[Vector2(row, col)] = null

func connectToGUI() -> void:
	var guiMap = get_parent().find_node("MapContainer", true, false)
	if guiMap != null:
		for child in guiMap.get_children():
			if child is MapElement:
				Utils.checkError(child.connect("stateChanged", self, "onGUIStatusChange"))

# @param pos The position of the room in (row,col)
# @param state The state of the MapElement
func onGUIStatusChange(pos:Vector2, state) -> void:
	if state != MapElement.State.HOVER && state != MapElement.State.EMPTY:
		var position:Position2D = positionMap.get(pos)
		var instance = basicRoom.instance()
		instance.global_position = position.position
		instance.gridPosition = pos
		get_parent().add_child(instance)
		placedMap[pos] = instance
		emit_signal("roomAdded", instance)

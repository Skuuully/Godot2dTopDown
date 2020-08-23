# Responsible for generating the grid of nodes that rooms may be placed at
extends Node2D
class_name WorldMap

signal roomAdded(room)

export(int) var rows:int
export(int) var cols:int
export(int) var xSpace:int
export(int) var ySpace:int

var basicRoom:PackedScene = preload("res://Prefabs/Rooms/BasicRoom.tscn")
var startRoom:PackedScene = preload("res://Prefabs/Rooms/StartRoom.tscn")

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
	
	createGUIGrid()
	placeStartRoomAtCenter()

func createGUIGrid() -> void:
	GlobalNodes.getGUIMap().initialiseGrid(rows, cols)

func placeStartRoomAtCenter() -> void:
	var startRoomInstance = startRoom.instance()
	var rowPos = floor(rows as float / 2.0)
	var colPos = floor(cols as float / 2.0)
	var gridPosition = Vector2(rowPos, colPos)
	startRoomInstance.global_position = positionMap.get(gridPosition).position
	get_parent().call_deferred("add_child", startRoomInstance)
	placedMap[gridPosition] = startRoomInstance
	emit_signal("roomAdded", startRoomInstance)
	GlobalNodes.getGUIMap().roomAdded(gridPosition, MapElement.State.ENEMY_ROOM)
	GlobalNodes.getPlayer().global_position = positionMap[gridPosition].position 
	GlobalNodes.getPlayer().global_position.x += 100
	GlobalNodes.getPlayer().global_position.y += 100

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
		placeRoom(basicRoom, pos)

func placeRoom(room:PackedScene, pos:Vector2) -> void:
	var position:Position2D = positionMap.get(pos)
	var instance = room.instance()
	instance.global_position = position.position
	instance.gridPosition = pos
	get_parent().add_child(instance)
	placedMap[pos] = instance
	emit_signal("roomAdded", instance)

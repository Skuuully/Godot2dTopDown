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
	for col in cols:
		for row in rows:
			var pos = Position2D.new()
			pos.position.x = col * xSpace
			pos.position.y = row * ySpace
			self.add_child(pos)
			var gridPos:Vector2 = Vector2(row, col)
			positionMap[gridPos] = pos
			placedMap[gridPos] = null
	
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
	startRoomInstance.tier = 1
	emit_signal("roomAdded", startRoomInstance)
	GlobalNodes.getGUIMap().roomAdded(gridPosition, MapElement.State.PLACED)
	GlobalNodes.getPlayer().global_position = positionMap[gridPosition].position 
	GlobalNodes.getPlayer().global_position.x += 100
	GlobalNodes.getPlayer().global_position.y += 100

func connectToGUI() -> void:
	var guiMap = get_parent().find_node("MapContainer", true, false)
	if guiMap != null:
		for child in guiMap.get_children():
			if child is MapElement:
				Utils.checkError(child.connect("roomPlaced", self, "onRoomPlaced"))

# @param pos The position of the room in (row,col)
# @param room The 
func onRoomPlaced(room, pos:Vector2) -> void:
	placeRoom(room.mapData, pos)

func placeRoom(mapData:MapData, pos:Vector2) -> void:
	var position:Position2D = positionMap.get(pos)
	var instance = mapData.scene.instance()
	instance.global_position = position.position
	instance.gridPosition = pos
	instance.tier = mapData.tier
	get_parent().add_child(instance)
	placedMap[pos] = instance
	emit_signal("roomAdded", instance)

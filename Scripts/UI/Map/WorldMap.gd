# Responsible for generating the grid of nodes that rooms may be placed at
extends Node2D
class_name WorldMap

signal roomAdded(room)

export(int) var rows:int
export(int) var cols:int
export(int) var xSpace:int
export(int) var ySpace:int

var basicRoom:MapData = MapData.new(preload("res://Prefabs/Rooms/EnemyRoom.tscn"),
									1, MapData.mapType.ENEMY)
var lootRoom:MapData = MapData.new(preload("res://Prefabs/Rooms/LootRoom.tscn"),
									1, MapData.mapType.LOOT)
var startRoom:MapData = MapData.new(preload("res://Prefabs/Rooms/StartRoom.tscn"),
									1, MapData.mapType.EMPTY)

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
	
	# Small wait before adding, the listener for adding rooms happens after this ready,
	# children of a node are readied before the parent
	yield(get_tree().create_timer(0.2), "timeout")
	placeStartRoomAtCenter()
	placeLootRoom(Vector2(Utils.randPosMin(1, 2), Utils.randPosMin(1, 2)))

func createGUIGrid() -> void:
	GlobalNodes.getGUIMap().initialiseGrid(rows, cols)

func placeStartRoomAtCenter() -> void:
	var rowPos = floor(rows as float / 2.0)
	var colPos = floor(cols as float / 2.0)
	var gridPosition = Vector2(rowPos, colPos)
	placeRoom(startRoom, gridPosition)
	GlobalNodes.getPlayer().global_position = positionMap[gridPosition].position 
	GlobalNodes.getPlayer().global_position.x += 100
	GlobalNodes.getPlayer().global_position.y += 100

func placeLootRoom(distFromCenter:Vector2) -> void:
	var center:Vector2 = Vector2(floor(rows as float / 2.0), floor(cols as float / 2.0))
	placeRoom(lootRoom, center + distFromCenter)

func placeRoom(room:MapData, gridPosition:Vector2) -> void:
	var roomInstance = room.scene.instance()
	roomInstance.global_position = positionMap.get(gridPosition).position
	roomInstance.gridPosition = gridPosition
	get_parent().call_deferred("add_child", roomInstance)
	placedMap[gridPosition] = roomInstance
	emit_signal("roomAdded", roomInstance)
	GlobalNodes.getGUIMap().roomAdded(gridPosition, room)

func connectToGUI() -> void:
	var guiMap = get_parent().find_node("MapContainer", true, false)
	if guiMap != null:
		for child in guiMap.get_children():
			if child is MapElement:
				Utils.checkError(child.connect("roomPlaced", self, "onRoomPlaced"))

# @param pos The position of the room in (row,col)
# @param room The 
func onRoomPlaced(room, pos:Vector2) -> void:
	placeMap(room.mapData, pos)

func placeMap(mapData:MapData, pos:Vector2) -> void:
	var position:Position2D = positionMap.get(pos)
	var instance = mapData.scene.instance()
	instance.global_position = position.position
	instance.gridPosition = pos
	instance.tier = mapData.tier
	get_parent().add_child(instance)
	placedMap[pos] = instance
	emit_signal("roomAdded", instance)

extends Control
class_name MapInventory

var inventorySize:int = 7
var rooms:Array = []

onready var inventoryGrid = $MapInventory

func _ready() -> void:
	inventoryGrid.columns = inventorySize
	var mapData = MapData.new(
		load("res://Prefabs/Rooms/BasicRoom.tscn"), 0, MapData.mapType.ENEMY)
	addRoom(mapData)
	get_parent().get_child(1).connectToMapElements(self)

func addRoom(map:MapData) -> bool:
	var added:bool = false
	var room = InventoryRoom.new(map)
	if rooms.size() < inventorySize:
		added = true
		rooms.append(room)
		inventoryGrid.add_child(room)
	
	return added

func removeRoom(room:InventoryRoom) -> void:
	var index:int = rooms.find(room)
	if index != -1:
		rooms.remove(index)

func onRoomPlaced(room, _pos) -> void:
	removeRoom(room)
	room.queue_free()


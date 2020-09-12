# MapInventoryUi
# Listens to the map inventory to handling the gui side of things
extends Control
class_name MapInventoryUi

var rooms:Array = []

onready var inventoryGrid = $MapInventory

func _ready() -> void:
	inventoryGrid.columns = PlayerInventory.getMapInventory().inventorySize
	Utils.checkError(PlayerInventory.getMapInventory().connect(
		"mapAdded", self, "onMapAddedToInventory"))
	Utils.checkError(PlayerInventory.getMapInventory().connect(
		"mapRemoved", self, "onMapRemovedFromInventory"))
	var alreadyAddedMaps = PlayerInventory.getMapInventory().getMaps()
	for map in alreadyAddedMaps:
		addRoom(map)

func addRoom(map:MapData) -> void:
	var room = preload("res://Prefabs/InventoryRoom.tscn").instance()
	room.mapData = map
	rooms.append(room)
	inventoryGrid.add_child(room)

func onMapAddedToInventory(map:MapData) -> void:
	addRoom(map)

func onMapRemovedFromInventory(map:MapData) -> void:
	var i = -1
	for room in rooms:
		i += 1
		if room.mapData == map:
			rooms.remove(i)
			room.queue_free()

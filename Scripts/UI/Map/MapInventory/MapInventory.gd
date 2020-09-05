extends Control

var inventorySize:int = 7
var rooms:Array = []

onready var inventoryGrid = $MapInventory

func _ready() -> void:
	inventoryGrid.columns = inventorySize
	for i in 5:
		var room = InventoryRoom.new(
			preload("res://Prefabs/Rooms/LootRoom.tscn"),
			preload("res://Sprites/icon.png"))
		addRoom(room)
		room = InventoryRoom.new(
			preload("res://Prefabs/Rooms/BasicRoom.tscn"),
			preload("res://Sprites/ball.png"))
		addRoom(room)
	get_parent().get_child(1).connectToMapElements(self)

func addRoom(room:InventoryRoom) -> void:
	if rooms.size() < inventorySize:
		rooms.append(room)
		inventoryGrid.add_child(room)

func removeRoom(room:InventoryRoom) -> void:
	var index:int = rooms.find(room)
	if index != -1:
		rooms.remove(index)

func onRoomPlaced(room, _pos) -> void:
	removeRoom(room)
	room.queue_free()


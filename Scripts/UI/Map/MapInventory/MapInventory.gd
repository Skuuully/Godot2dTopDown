extends Control

var inventorySize:int = 7
var rooms:Array = []

onready var inventoryGrid = $MapInventory

func _ready() -> void:
	inventoryGrid.columns = inventorySize
	for i in 10:
		var room = InventoryRoom.new(
			preload("res://Prefabs/Rooms/BasicRoom.tscn"),
			preload("res://Sprites/icon.png"))
		addRoom(room)

func addRoom(room:InventoryRoom) -> void:
	if rooms.size() < inventorySize:
		rooms.append(room)
		inventoryGrid.add_child(room)


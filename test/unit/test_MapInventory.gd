extends "res://addons/gut/test.gd"

func before_each():
	# Start with clean set of maps
	var mapInventory = PlayerInventory.getMapInventory()
	mapInventory.maps.clear()

func test_canAdd() -> void:
	var mapInventory = PlayerInventory.getMapInventory()
	assert_true(mapInventory.canAddMap())

func test_addOverSize() -> void:
	var mapInventory = PlayerInventory.getMapInventory()
	for i in mapInventory.inventorySize:
		mapInventory.addMap(MapData.new(load(""), 1, MapData.mapType.EMPTY))
	assert_false(mapInventory.canAddMap())

func test_canAddLast() -> void:
	var mapInventory = PlayerInventory.getMapInventory()
	for i in mapInventory.inventorySize - 1:
		mapInventory.addMap(MapData.new(load(""), 1, MapData.mapType.EMPTY))
	assert_true(mapInventory.canAddMap())

func test_hasEnemyRoom() -> void:
	var mapInventory = PlayerInventory.getMapInventory()
	mapInventory.addMap(MapData.new(load(""), 1, MapData.mapType.ENEMY))
	mapInventory.addMap(MapData.new(load(""), 1, MapData.mapType.EMPTY))
	assert_true(mapInventory.hasEnemyRoom())

func test_doesNotHaveEnemyRoom() -> void:
	var mapInventory = PlayerInventory.getMapInventory()
	mapInventory.addMap(MapData.new(load(""), 1, MapData.mapType.EMPTY))
	mapInventory.addMap(MapData.new(load(""), 1, MapData.mapType.EMPTY))
	mapInventory.addMap(MapData.new(load(""), 1, MapData.mapType.EMPTY))
	assert_false(mapInventory.hasEnemyRoom())

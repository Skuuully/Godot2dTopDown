extends Node2D
class_name WorldMap

signal roomAdded(room)

export var rows:int
export var cols:int
export var xSpace:int
export var ySpace:int

var basicRoom = preload("res://Prefabs/Rooms/BasicRoom.tscn")

# Map of vector2 to Position2D
var map = {}

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
			map[Vector2(row, col)] = pos

func connectToGUI() -> void:
	var guiMap = get_parent().find_node("MapContainer", true, false)
	if guiMap != null:
		for child in guiMap.get_children():
			if child is MapElement:
				Globals.checkError(child.connect("stateChanged", self, "onGUIStatusChange"))
	pass

func onGUIStatusChange(pos:Vector2, state) -> void:
	if state != MapElement.State.HOVER && state != MapElement.State.EMPTY:
		var position:Position2D = map.get(pos)
		var instance = basicRoom.instance()
		instance.global_position = position.position
		get_parent().add_child(instance)
		emit_signal("roomAdded", instance)
		
	pass

# MapElement
# A grid tile that represents a room in the map
extends TextureRect
class_name MapElement

signal roomPlaced(mapData, pos)

enum State {EMPTY, HOVER, PLACED, UNPLACEABLE}
var currState = State.EMPTY

export(Color) var emptyColour = Color(1.0, 1.0, 1.0, 1.0)
export(Color) var hoverColour = Color(1.0, 1.0, 1.0, 1.0)
export(Color) var placedColour = Color(1.0, 1.0, 1.0, 1.0)
export(Color) var unplaceableColour = Color(1.0, 1.0, 1.0, 1.0)

export(bool) var containsPlayer:bool setget setContainsPlayer
var gridPosition:Vector2 = Vector2(-1, -1)
var mapData:MapData = null setget setMapData

export(bool) var hidden:bool = false setget setHidden
export var hiddenTexture:Texture = preload("res://Sprites/UI/MapIcons/QuestionMark.png")

func _ready():
	Utils.checkError(self.connect("mouse_entered", self, "mouse_entered"))
	Utils.checkError(self.connect("mouse_exited", self, "mouse_exited"))
	changeState(State.EMPTY)

func changeState(newState) -> void:
	currState = newState
	
	if (!hidden):
		match (currState):
			State.EMPTY:
				modulate = emptyColour
			State.HOVER:
				modulate = hoverColour
			State.PLACED:
				modulate = placedColour
			State.UNPLACEABLE:
				modulate = unplaceableColour

func mouse_entered():
	if (currState == State.EMPTY):
		changeState(State.HOVER)

func mouse_exited() -> void:
	if (currState == State.HOVER):
		changeState(State.EMPTY)

func setContainsPlayer(contains:bool) -> void:
	containsPlayer = contains
	$PlayerBorder.visible = contains

func can_drop_data(_position, data):
	return currState == State.HOVER && data is InventoryRoom

func drop_data(_position, data):
	var room:InventoryRoom = data as InventoryRoom
	mapData = room.mapData
	PlayerInventory.getMapInventory().removeMap(mapData)
	updateRoomIcon()
	changeState(State.PLACED)
	emit_signal("roomPlaced", room, gridPosition)

func clearIcon() -> void:
	$RoomType.texture = null

func updateRoomIcon() -> void:
	if hidden:
		modulate = Color(0.0, 0.0, 0.1, 1.0)
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if mapData == null || mapData.texture == null:
		$RoomType.texture = null
		$RoomType.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		if hidden:
			$RoomType.texture = hiddenTexture
			$RoomType.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			$RoomType.texture = mapData.texture
			$RoomType.modulate = mapData.borderColour

func setHidden(value:bool) -> void:
	hidden = value
	updateRoomIcon()

func setMapData(data) -> void:
	mapData = data
	updateRoomIcon()

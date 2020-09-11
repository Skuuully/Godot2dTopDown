# Map element, a grid tile that represents a room in the map
extends TextureRect
class_name MapElement

signal roomPlaced(mapData, pos)

enum State {EMPTY, HOVER, PLACED}
var currState = State.EMPTY

export(bool) var containsPlayer:bool setget setContainsPlayer
var gridPosition:Vector2 = Vector2(-1, -1)

var hoverTexture:Texture = preload("res://Sprites/UI/MapIcons/Hover.png")
export var emptyTexture:Texture = preload("res://Sprites/UI/MapIcons/EmptyRoom.png")
export var placedTexture:Texture = preload("res://Sprites/UI/MapIcons/EnemyRoom.png")

func _ready():
	Utils.checkError(self.connect("mouse_entered", self, "mouse_entered"))
	Utils.checkError(self.connect("mouse_exited", self, "mouse_exited"))

func changeState(newState) -> void:
	currState = newState
	match (currState):
		State.EMPTY:
			texture = emptyTexture
		State.HOVER:
			texture = hoverTexture
		State.PLACED:
			texture = placedTexture

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
	var mapData = room.mapData
	$RoomType.texture = mapData.texture
	$RoomType.modulate = mapData.borderColour
	changeState(State.PLACED)
	emit_signal("roomPlaced", room.mapData, gridPosition)

func clearIcon() -> void:
	$RoomType.texture = null

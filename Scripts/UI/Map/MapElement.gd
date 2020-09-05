# Map element, a grid tile that represents a room in the map
extends TextureRect
class_name MapElement

signal roomPlaced(room, pos)

enum State {EMPTY, HOVER, EMPTY_ROOM, ENEMY_ROOM, LOOT}
var currState = State.EMPTY

export(bool) var containsPlayer:bool setget setContainsPlayer

var hoverTexture:Texture = preload("res://Sprites/UI/MapIcons/Hover.png")
export var emptyTexture:Texture = preload("res://Sprites/UI/MapIcons/EmptyRoom.png")
export var emptyRoomTexture:Texture = preload("res://Sprites/UI/MapIcons/EmptyRoom.png")
export var enemyRoomTexture:Texture = preload("res://Sprites/UI/MapIcons/EnemyRoom.png")

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
		State.EMPTY_ROOM:
			texture = emptyRoomTexture
		State.ENEMY_ROOM:
			texture = enemyRoomTexture
		State.LOOT:
			texture = enemyRoomTexture

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
	match (room.thisType):
		room.type.EMPTY:
			changeState(State.EMPTY)
		room.type.ENEMY:
			changeState(State.ENEMY_ROOM)
		room.type.LOOT:
			changeState(State.LOOT)
	emit_signal("roomPlaced", room, get_parent().getPosition(self))

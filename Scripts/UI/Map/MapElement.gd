# Map element, a grid tile that represents a room in the map
extends TextureRect
class_name MapElement

signal stateChanged(pos, state)

enum State {EMPTY, HOVER, EMPTY_ROOM, ENEMY_ROOM}
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
	
	emit_signal("stateChanged", get_parent().getPosition(self), currState)

func mouse_entered():
	if (currState == State.EMPTY):
		changeState(State.HOVER)

func mouse_exited() -> void:
	if (currState == State.HOVER):
		changeState(State.EMPTY)

func _input(event) -> void:
	if (event.get_action_strength("lmb") && currState == State.HOVER):
		changeState(State.ENEMY_ROOM)

func setContainsPlayer(contains:bool) -> void:
	containsPlayer = contains
	$PlayerBorder.visible = contains

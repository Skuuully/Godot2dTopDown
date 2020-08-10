# Map element, a grid tile that represents a room in the map

extends TextureRect
class_name MapElement

signal stateChanged(pos, state)

enum State {EMPTY, HOVER, EMPTY_ROOM, ENEMY_ROOM}
var currState = State.EMPTY
var hoverTexture:Texture = preload("../Sprites/MapIcons/Hover.png")
var emptyTexture:Texture = preload("../Sprites/MapIcons/EmptyRoom.png")
var emptyRoomTexture:Texture = preload("../Sprites/icon.png")
var enemyRoomTexture:Texture = preload("../Sprites/MapIcons/EnemyRoom.png")

func _ready():
	Globals.checkError(self.connect("mouse_entered", self, "mouse_entered"))
	Globals.checkError(self.connect("mouse_exited", self, "mouse_exited"))

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

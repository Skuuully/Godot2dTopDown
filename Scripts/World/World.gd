# World

extends Node2D

# The player node
onready var player:Player = $Player

# The player camera, used when no room is currently active
onready var _playerCamera = $PlayerCamera

# The currently active room
onready var _activeRoom = null

onready var _gui = $GUI
onready var worldMap = $WorldMap

# The text to instantiate when a bullet collides
var dmgText = preload("res://Prefabs/Combat/DamageText.tscn")

func _ready():
	Utils.checkError(player.connect("moved", self, "_onPlayerMove"))
	Utils.checkError(player.damageable.connect("damageTaken", self, "_onPlayerDamageTaken"))
	Utils.checkError(worldMap.connect("roomAdded", self, "_onRoomAdded"))

# Handler for when the player moves
func _onPlayerMove(playerPosition):
	# Inform the active room of the player position
	if _activeRoom != null:
		_activeRoom.playerMoved(playerPosition)
	_playerCamera.playerMoved(playerPosition)

func _playerExited():
	_playerCamera.activateCamera(_activeRoom.getCameraPosition())
	_activeRoom.deactivate()

func _playerEntered(newRoom):
	_activeRoom = newRoom
	_activeRoom.activate()

func _onPlayerDamageTaken() -> void:
	_gui.updateLife(player.getLife(), player.MAX_LIFE)

func _onRoomAdded(room:Room) -> void:
	Utils.checkError(room.connect("playerExited", self, "_playerExited"))
	Utils.checkError(room.connect("playerEntered", self, "_playerEntered"))

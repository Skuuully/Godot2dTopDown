# World

extends Node2D

# The player node
onready var player:Player = $Player

# The player camera, used when no room is currently active
onready var _playerCamera = $PlayerCamera

# The bullet manager
onready var _bulletManager = $BulletManager

# The currently active room
onready var _activeRoom = $StartRoom

onready var _gui = $GUI
onready var worldMap = $WorldMap

# The text to instantiate when a bullet collides
var dmgText = preload("res://Prefabs/DamageText.tscn")

func _ready():
	Globals.checkError(player.connect("moved", self, "_onPlayerMove"))
	Globals.checkError(player.damageable.connect("damageTaken", self, "_onPlayerDamageTaken"))
	Globals.checkError(worldMap.connect("roomAdded", self, "_onRoomAdded"))
	
	for child in get_children():
		if (child != null) && child.has_method("isRoom"):
			Globals.checkError(child.connect("playerExited", self, "_playerExited"))
			Globals.checkError(child.connect("playerEntered", self, "_playerEntered"))
	
	_activeRoom.activateCamera()

# Handler for when the player moves
func _onPlayerMove(playerPosition):
	# Inform the active room of the player position
	_activeRoom.playerMoved(playerPosition)
	_playerCamera.playerMoved(playerPosition)

func getAllBullets():
	return _bulletManager.getAllBullets()

func _playerExited():
	_playerCamera.activateCamera(_activeRoom.getCameraPosition())
	_activeRoom.deactivate()
	pass

func _playerEntered(newRoom):
	_activeRoom = newRoom
	_activeRoom.activate()
	pass

func _onPlayerDamageTaken() -> void:
	_gui.updateLife(player.getLife(), player.MAX_LIFE)
	pass

func _onRoomAdded(room:Room) -> void:
	Globals.checkError(room.connect("playerExited", self, "_playerExited"))
	Globals.checkError(room.connect("playerEntered", self, "_playerEntered"))

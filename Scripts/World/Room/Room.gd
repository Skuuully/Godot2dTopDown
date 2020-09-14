# Room

extends Node2D
class_name Room

enum state {ACTIVE, INACTIVE}
var currentState

onready var _navigation = $RoomNavigation setget , getNavigation
onready var _camera = $RoomCamera
onready var bounds = $RoomBounds
onready var doors = $Doors
onready var lootSpawn = $LootSpawn
onready var enemySpawn = $EnemySpawnSystem
onready var enemies = $Enemies

var tier:int = 1
var gridPosition:Vector2 = Vector2(-1, -1)

signal playerExited()
signal playerEntered()

func _ready():
	# Connect to room bounds, enter and exit methods
	Utils.checkError(bounds.connect("body_entered", self, "_bodyEntered"))
	Utils.checkError(bounds.connect("body_exited", self, "_bodyExited"))
	if enemies != null:
		Utils.checkError(enemies.connect("enemiesDefeated", self, "roomCleared"))

func activateCamera():
	_camera.current = true
	currentState = state.ACTIVE

func getNavigation():
	return _navigation

# When the player moves the route for the enemies should be updated
func playerMoved(inPosition):
	if currentState == state.ACTIVE:
		_navigation.setPlayerPosition(inPosition)
	
		if enemies != null:
			enemies.updatePlayerPosition(inPosition)

# Handler for room bounds body entered method
func _bodyEntered(body):
	if body.has_method("isPlayer"):
		activateCamera()
		emit_signal("playerEntered", self)
		if enemySpawn != null:
			enemySpawn.spawnEnemies(tier)
			activate()

# Handler for room bounds body exited method
func _bodyExited(body):
	if body.has_method("isPlayer"):
		currentState = state.INACTIVE
		emit_signal("playerExited")

func getCameraPosition():
	return _camera.position

# @param currentPosition The current position to go from in local space to the room
func getRouteToPlayer(var currentPosition:Vector2):
	return _navigation.getRouteToPlayer(currentPosition)

func calculateRoute(var currentPosition:Vector2, var targetPosition:Vector2) -> PoolVector2Array:
	return _navigation.getRoute(currentPosition, targetPosition)

func activate() -> void:
	activateCamera()
	if enemies != null && enemies.hasEnemies():
		GlobalNodes.getGUI().hideNonCombat()
		doors.close()
		enemies.activateEnemies(true)
	GlobalNodes.getGUIMap().playerEnteredRoom(gridPosition)

func deactivate() -> void:
	if enemies != null:
		enemies.activateEnemies(false)

func roomCleared() -> void:
	GlobalNodes.getGUIMap().clearCurrentRoomIcon()
	doors.open()
	GlobalNodes.getGUI().showNonCombat()
	lootSpawn.spawnLoot(tier)

# Method that can be cheked for on nodes to determine if the node is a room
# node.has_method("isRoom") will return true, the method need not do anything
# special
func isRoom():
	pass

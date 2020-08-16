# Room

extends Node2D
class_name Room

enum state {ACTIVE, INACTIVE}
var currentState

# The rooms naviagatable area for AI
onready var _navigation = $RoomNavigation setget , getNavigation

# The rooms camera instance
onready var _camera = $RoomCamera

# The bounds of the room
onready var bounds = $RoomBounds

# Rooms doors
onready var doors = $Doors

# The enemies in the room
var _enemies = Array()

var gridPosition:Vector2 = Vector2(0, 0)

signal playerExited()
signal playerEntered()

func _ready():
	# Get all enemies in the room and add to list, connect to on death so they 
	# may be removed from the list
	for child in get_children():
		if (child != null) && child.has_method("isEnemy"):
			_enemies.push_back(child)
			child.connect("died", self, "_onEnemyDeath")
	
	# Connect to room bounds, enter and exit methods
	bounds.connect("body_entered", self, "_bodyEntered")
	bounds.connect("body_exited", self, "_bodyExited")

func activateCamera():
	_camera.current = true
	currentState = state.ACTIVE

func getNavigation():
	return _navigation

# When the player moves the route for the enemies should be updated
func playerMoved(position):
	if currentState == state.ACTIVE:
		_navigation.setPlayerPosition(position)
	
		for enemy in _enemies:
			if enemy.has_method("setRoute"):
				enemy.setRoute(_navigation.getRouteToPlayer(enemy.global_position))
			elif enemy.has_method("setPlayerPosition"):
				enemy.setPlayerPosition(position)
		
		# SFI: This is probably really expensive for how much it will be called
		# Should be handled by _bodyEntered and _bodyExited however sadly they 
		# are fired in the wrong order on teleporting the player through the 
		# doors
		if bounds.overlaps_body(GlobalNodes.getPlayer()):
			activate()

# Handler for room bounds body entered method
func _bodyEntered(body):
	if body.has_method("isPlayer"):
		activateCamera()
		emit_signal("playerEntered", self)

# Handler for room bounds body exited method
func _bodyExited(body):
	if body.has_method("isPlayer"):
		currentState = state.INACTIVE
		emit_signal("playerExited")

# Handler for enemy on death
func _onEnemyDeath(enemy):
	_enemies.erase(enemy)
	if _enemies.size() < 1:
		roomCleared()

func getCameraPosition():
	return _camera.position

# @param currentPosition The current position to go from in local space to the room
func getRouteToPlayer(var currentPosition:Vector2):
	return _navigation.getRouteToPlayer(currentPosition)

func calculateRoute(var currentPosition:Vector2, var targetPosition:Vector2) -> PoolVector2Array:
	return _navigation.getRoute(currentPosition, targetPosition)

func activate() -> void:
	activateCamera()
	if _enemies.size() > 0:
		GlobalNodes.getGUI().hideNonCombat()
		doors.close()
		for enemy in _enemies:
			if enemy.has_method("setActive"):
				enemy.setActive(true)

func deactivate() -> void:
	for enemy in _enemies:
		if enemy.has_method("setActive"):
			enemy.setActive(false)

func roomCleared() -> void:
	doors.open()
	GlobalNodes.getGUI().showNonCombat()

# Method that can be cheked for on nodes to determine if the node is a room
# node.has_method("isRoom") will return true, the method need not do anything
# special
func isRoom():
	pass

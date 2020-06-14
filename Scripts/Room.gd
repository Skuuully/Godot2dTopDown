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

# The enemies in the room
var _enemies = Array()

signal playerExited()
signal playerEntered()

func _ready():
	# Get all enemies in the room and add to list, connect to on death so they 
	# may be removed from the list
	for child in get_children():
		if (child != null) && child.has_method("isEnemy"):
			_enemies.push_back(child)
			child.connect("onDeath", self, "_onEnemyDeath")
	
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
				enemy.setRoute(_navigation._getRouteToPlayer(enemy.global_position))
			elif enemy.has_method("setPlayerPosition"):
				enemy.setPlayerPosition(position)

# Handler for room bounds body entered method
func _bodyEntered(body):
	if body.has_method("isPlayer"):
		currentState = state.ACTIVE
		_camera.current = true
		emit_signal("playerEntered", self)

# Handler for room bounds body exited method
func _bodyExited(body):
	if body.has_method("isPlayer"):
		currentState = state.INACTIVE
		emit_signal("playerExited")

# Handler for enemy on death
func _onEnemyDeath(enemy):
	_enemies.erase(enemy)

func getCameraPosition():
	return _camera.position

func calculateRoute(var currentPosition:Vector2, var targetPosition:Vector2) -> PoolVector2Array:
	return _navigation.getRoute(currentPosition, targetPosition)

# Method that can be cheked for on nodes to determine if the node is a room
# node.has_method("isRoom") will return true, the method need not do anything
# special
func isRoom():
	pass

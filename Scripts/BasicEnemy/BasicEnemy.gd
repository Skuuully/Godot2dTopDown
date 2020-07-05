extends Node2D
class_name BasicEnemy

signal died()

var rng = RandomNumberGenerator.new()

onready var stateMachine = $StateMachine
var _targetPosition
var MOVE_RANGE:int = 50
var active:bool = false setget setActive

onready var damageable = $Damageable

func _ready() -> void:
	 Globals.checkError(damageable.connect("died", self, "_onDeath"))

func setPlayerPosition(var playerPosition:Vector2) -> void:
	_targetPosition = playerPosition
	stateMachine.playerMoved(playerPosition)
	pass

# Return - A route to get to a point within  
func getRandCircularPoint():
	var route = null
	
	var parent = get_parent()
	if parent != null && parent is Room:
		var room:Room = parent as Room
		# Get a Vector2 as some random point on the edge of a circle
		
		rng.randomize()
		var x:float = rng.randf_range(-1, 1) * MOVE_RANGE
		var y:float = rng.randf_range(-1, 1) * MOVE_RANGE
		var normalized = Vector2(x, y).normalized()
		var includeRange = normalized * MOVE_RANGE
		var target:Vector2 = Vector2(global_position.x + includeRange.x, global_position.y + includeRange.y)
		print("target: " + str(target))
		route = room.calculateRoute(global_position, target)
	
	return route

func _onDeath(_bullet:Bullet) -> void:
	emit_signal("died")
	queue_free()

func setActive(newActive:bool) -> void:
	if active != newActive:
		active = newActive
		stateMachine.changeState(stateMachine.State.IDLE)

# Method that can be cheked for on nodes to determine if the node is an enemy
# node.has_method("isEnemy") will return true, the method need not do anything
# special
func isEnemy():
	pass

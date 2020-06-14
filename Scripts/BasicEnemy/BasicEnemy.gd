extends Node2D
class_name BasicEnemy

var rng = RandomNumberGenerator.new()

onready var stateMachine = $StateMachine
var _targetPosition
var MOVE_RANGE:int = 50

func setPlayerPosition(var playerPosition:Vector2) -> void:
	_targetPosition = playerPosition
	
	pass

# Return - A route to get to a point within  
func getRandCircularPoint():
	var route = null
	
	var parent = get_parent()
	if parent != null && parent is Room:
		var room:Room = parent as Room
		# Get a Vector2 as some random point on the edge of a circle
		
		rng.randomize()
		var x:float = rng.randf_range(-1, 1)
		var y:float = rng.randf_range(-1, 1)
		var target:Vector2 = Vector2(x * MOVE_RANGE, y * MOVE_RANGE).normalized()
		route = room.calculateRoute(global_position, target)
	
	return route

# Method that can be cheked for on nodes to determine if the node is an enemy
# node.has_method("isEnemy") will return true, the method need not do anything
# special
func isEnemy():
	pass

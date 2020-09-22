extends BaseEnemy

onready var stateMachine = $StateMachine
export var MOVE_RANGE:int = 50

func setPlayerPosition(value:Vector2) -> void:
	.setPlayerPosition(value)
	if stateMachine != null:
		stateMachine.playerMoved(value)

# Return - A route to get to a point within  
func getRandCircularPoint():
	var route = null
	
	var parent = get_parent().get_parent()
	if parent != null && parent is Room:
		var room:Room = parent as Room
		# Get a Vector2 as some random point on the edge of a circle
		
		randomize()
		var x:float = rand_range(-1, 1) * MOVE_RANGE
		var y:float = rand_range(-1, 1) * MOVE_RANGE
		var normalized = Vector2(x, y).normalized()
		var includeRange = normalized * MOVE_RANGE
		var target:Vector2 = Vector2(
			position.x + includeRange.x, position.y + includeRange.y)
		route = room.calculateRoute(position, target)

	return route

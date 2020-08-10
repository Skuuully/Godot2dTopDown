# EnemyNavigation2D

extends Navigation2D

var _playerPosition setget setPlayerPosition

func _getRouteToPlayer(from):
	return convertToGlobal(get_simple_path(from, _playerPosition))

func getRoute(var startPosition:Vector2, var targetPosition:Vector2) -> PoolVector2Array:
	var closestPt:Vector2 = get_closest_point(targetPosition)
	return convertToGlobal(get_simple_path(startPosition, closestPt))

# Converts the points of a route global position
func convertToGlobal(route:PoolVector2Array) -> PoolVector2Array:
	var i = 0
	for point in route:
		point += get_parent().position
		route[i] = point
		i += 1
	
	return route

func setPlayerPosition(position):
	# minus the parents position(room position) to get the player position 
	# relative to the room
	_playerPosition = position - get_parent().position

# EnemyNavigation2D

extends Navigation2D

var _playerPosition setget setPlayerPosition

func _getRouteToPlayer(from):
	# Gets the path in local space
	var route = get_simple_path(from, _playerPosition)
	
	# Convert points to global space
	var i = 0
	for point in route:
		point += get_parent().position
		route[i] = point
	
	return route

func setPlayerPosition(position):
	# minus the parents position(room position) to get the player position 
	# relative to the room
	_playerPosition = position - get_parent().position

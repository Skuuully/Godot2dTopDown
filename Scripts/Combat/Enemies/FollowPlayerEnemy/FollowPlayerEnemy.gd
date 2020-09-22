extends BaseEnemy
class_name FollowPlayerEnemy

onready var stateMachine = $StateMachine

func setPlayerPosition(value:Vector2) -> void:
	.setPlayerPosition(value)
	if stateMachine != null:
		stateMachine.playerMoved(value)

func getRouteToPlayer():
	var route = null
	
	var parent = get_parent().get_parent()
	if parent != null && parent is Room && (playerPosition != null):
		var room:Room = parent as Room
		route = room.getRouteToPlayer(position)
	
	return route

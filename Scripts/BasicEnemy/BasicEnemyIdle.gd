extends BasicEnemyState
class_name BasicEnemyIdle

func enter() -> void:
	# Change the animation to idle
	pass

func playerMoved(var playerPosition:Vector2) -> void:
	var base:BasicEnemy = _stateMachine.get_parent()
	if base != null:
		_stateMachine.movingState.setRoute(base.getRandCircularPoint())
	pass

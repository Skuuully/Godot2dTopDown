extends EnemyState
class_name BasicEnemyIdle

func enter() -> void:
	# Change the animation to idle
	var base = _stateMachine.get_parent()
	if base != null:
		_stateMachine.movingState.setRoute(base.getRandCircularPoint())
		_stateMachine.changeState(BasicEnemyStateMachine.State.MOVING)

func playerMoved() -> void:
	var base = _stateMachine.get_parent()
	if base != null:
		_stateMachine.movingState.setRoute(base.getRandCircularPoint())
		_stateMachine.changeState(BasicEnemyStateMachine.State.MOVING)
	else:
		print("player moved but base null")

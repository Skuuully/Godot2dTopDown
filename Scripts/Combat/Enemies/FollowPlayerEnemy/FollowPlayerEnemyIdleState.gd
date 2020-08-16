extends EnemyState

func enter() -> void:
	# Change the animation to idle
	var base:FollowPlayerEnemy = _stateMachine.get_parent()
	if base != null:
		if base.active:
			_stateMachine.changeState(FollowPlayerEnemyStateMachine.State.FOLLOW)

func playerMoved() -> void:
	var base:FollowPlayerEnemy = _stateMachine.get_parent()
	if base != null:
		_stateMachine.changeState(FollowPlayerEnemyStateMachine.State.FOLLOW)
	else:
		print("player moved but base null")

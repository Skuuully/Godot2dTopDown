extends EnemyState

# Waits before going back to idle state
func enter() -> void:
	yield(get_tree().create_timer(0.3), "timeout")
	_stateMachine.changeState(_stateMachine.State.IDLE)
	pass

extends BasicEnemyState
class_name BasicEnemyMoving

var _route = null

func enter() -> void:
	# Change the animation state to moving
	_findRoute()

func update() -> void:
	_followRoute()
	pass

func _followRoute() -> void:
	if _route != null && _route.size > 0:
		pass
		
		# At end of route now transition to shoot
		_stateMachine.changeState(BasicEnemyStateMachine.State.SHOOTING)
	pass

func _findRoute() -> void:
	# Setup the route using the navigation mesh
	pass

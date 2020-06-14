extends BasicEnemyState
class_name BasicEnemyMoving

var _route = null
var MOVE_SPEED:int = 20

func enter() -> void:
	# Change the animation state to moving
	if _route != null:
		_findRoute()

func update() -> void:
	_followRoute()
	pass

func _followRoute() -> void:
	if (_route == null) || (_route.size() < 0):
		_stateMachine.changeState(BasicEnemyStateMachine.State.IDLE)
	else:
		# There is a route set so go ahead and follow it
		var rigidbodyNode = _stateMachine.get_parent()
		var dir:Vector2 = (_route[0] - rigidbodyNode.global_position).normalized()
		
		if dir == Vector2.ZERO:
			_route.remove(0)
			dir = (_route[0] - rigidbodyNode.global_position).normalized()

		rigidbodyNode.move_and_slide(dir * MOVE_SPEED)
		
		if rigidbodyNode.global_position == _route[0]:
			_route.remove(0)
			if _route.size() < 1:
				# At end of route now transition to shoot
				_route = null
				_stateMachine.changeState(BasicEnemyStateMachine.State.SHOOTING)

func _findRoute() -> void:
	# The base enemy node
	var baseNode = _stateMachine.get_parent()
	if baseNode != null:
		var base:BasicEnemy = baseNode as BasicEnemy
		_route = base.getRandCircularPoint()

func setRoute(var route:PoolVector2Array) -> void:
	_route = route

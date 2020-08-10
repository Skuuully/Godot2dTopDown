extends BasicEnemyState
class_name BasicEnemyMoving

var _route = null
var _targetArea:Rect2 = Rect2(0, 0, 0, 0)
var MOVE_SPEED:int = 20
var NEAR_POINT:int = 5

func enter() -> void:
	# Change the animation state to moving
	if _route == null:
		_findRoute()

func update() -> void:
	_followRoute()
	pass

func _followRoute() -> void:
	if (_route == null) || (_route.size() < 0):
		_stateMachine.changeState(BasicEnemyStateMachine.State.IDLE)
	else:
		# There is a route set so go ahead and follow it
		var kinematicNode = _stateMachine.get_parent()
		var dir:Vector2 = (_route[0] - kinematicNode.global_position).normalized()
		
		if dir == Vector2.ZERO:
			_route.remove(0)
			dir = (_route[0] - kinematicNode.global_position).normalized()

		var moveAmount:Vector2 = dir * MOVE_SPEED
		kinematicNode.move_and_slide(moveAmount)
		
		if _targetArea.has_point(kinematicNode.global_position):
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
		setRoute(base.getRandCircularPoint())

func setRoute(var route:PoolVector2Array) -> void:
	_route = route
	if route != null && route.size() > 0:
		var lastPoint = route[route.size() - 1]
		var targetTopLeft = Vector2(lastPoint.x - (NEAR_POINT/2.0), lastPoint.y - (NEAR_POINT/2.0))
		_targetArea = Rect2(targetTopLeft, Vector2(NEAR_POINT, NEAR_POINT))

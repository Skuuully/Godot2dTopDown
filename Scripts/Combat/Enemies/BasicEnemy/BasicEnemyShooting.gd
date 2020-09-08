extends EnemyState

export var BULLET_DMG:int = 1
export var BULLET_COUNT:int = 4
export var BULLET_SPEED:int = 120
onready var center:Position2D = $CenterPoint
onready var outer:Position2D = $ProjSpawn 

func enter() -> void:
	# Change the animation to the shooting animation
	_shoot()
	pass

func _shoot() -> void:
	yield(get_tree().create_timer(0.4), "timeout")
	_createProjectiles()
	yield(get_tree().create_timer(0.1), "timeout")
	_stateMachine.changeState(_stateMachine.State.IDLE)

func _createProjectiles() -> void:
	# Setup global positions
	var outerX:float = outer.global_position.x
	var outerY:float = outer.global_position.y
	var centerX:float = center.global_position.x
	var centerY:float = center.global_position.y

	# Create initial projectile
	var init:Vector2 = Vector2(outerX - centerX, outerY - centerY)
	var angleIncrement:float = 360.0 / BULLET_COUNT
	_createProj(init, Vector2(outerX, outerY))

	for i in range(1, BULLET_COUNT):
		var x2 = init.x * cos(deg2rad(angleIncrement * i)) - init.y * sin(deg2rad(angleIncrement * i))
		var y2 = init.x * sin(deg2rad(angleIncrement * i)) + init.y * cos(deg2rad(angleIncrement * i))
		var vel:Vector2 = Vector2(x2, y2).normalized()
		var pos:Vector2 = Vector2(centerX + x2, centerY + y2)
		_createProj(vel, pos)

func _createProj(velocity:Vector2, position:Vector2) -> void:
	var bulletInstance:Bullet = BulletManager.getBullet()
	bulletInstance.setCreator(_stateMachine.get_parent())
	bulletInstance.setDamage(BULLET_DMG)
	bulletInstance.linear_velocity = velocity.normalized() * BULLET_SPEED
	bulletInstance.position = position
	pass

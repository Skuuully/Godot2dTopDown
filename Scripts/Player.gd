# Player

extends KinematicBody2D
class_name Player

# Movement based stuff
export var ACCELERATION:float = 100
export var MAX_SPEED:float = 100

export var MAX_LIFE:int = 6;
var _life:int = MAX_LIFE setget , getLife;

# Bullet based stuff
export var BULLETSPEED:float = 120;
export var TIMEBETWEENSHOTS:float = 0.2
export var BULLETDAMAGE:float = 1;
var projectile:PackedScene = preload("res://Prefabs/Bullet.tscn")

onready var gunTimer:Timer = $GunTimer
onready var invincibleTimer:Timer = $InvincibleTimer
onready var collisionShape:CollisionShape2D = $CollisionShape2D
onready var screenEffectPlayer:AnimationPlayer = $ScreenEffectPlayer
onready var shockwave:ColorRect = $ScreenRenderLayer/Shockwave

# fired when player positions changes, additionally sends out new position
signal moved()
signal _bulletCreated(newBullet)
signal damageTaken()

func _physics_process(_delta) -> void:
	move()
	shoot()
	checkCollisions()

# Moves the player
func move() -> void:
	var xInput:float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var yInput:float = Input.get_action_strength("down") - Input.get_action_strength("up")

	if xInput != 0 || yInput != 0:
		var movement:Vector2 = Vector2(xInput, yInput)
		movement = movement.normalized()
		movement *= ACCELERATION
		movement.x = clamp(movement.x, -MAX_SPEED, MAX_SPEED)
		movement.y = clamp(movement.y, -MAX_SPEED, MAX_SPEED)
		move_and_slide(movement, Vector2.UP)
		emit_signal("moved", global_position)

func shoot() -> void:
	var leftClick:float = Input.get_action_strength("lmb")
	if leftClick != 0 && gunTimer.is_stopped():
		createProj()

func createProj() -> void:
	gunTimer.start(TIMEBETWEENSHOTS)
	var projInstance:Bullet = projectile.instance()
	get_tree().get_root().add_child(projInstance)
	emit_signal("_bulletCreated", projInstance)
	projInstance.setDamage(BULLETDAMAGE)

	var mousePos:Vector2 = get_global_mouse_position()
	var bulletDirection:Vector2 = (mousePos - position).normalized()
	projInstance.linear_velocity = bulletDirection * BULLETSPEED
	projInstance.set_position(position + (bulletDirection * 25))

func checkCollisions() -> void:
	for i in get_slide_count():
		var collision:KinematicCollision2D = get_slide_collision(i);
		if collision.collider as Enemy:
			onDamageTaken()
	pass

func onDamageTaken() -> void:
	if invincibleTimer.is_stopped():
		_life -= 1;
		emit_signal("damageTaken")
		if (_life <= 0):
			died()
		else:
			doShockwave()
			flash()
			invincibleTimer.start()

func doShockwave() -> void:
	# Get the top left position of the camera
	var topLeft:Vector2 = -get_canvas_transform().get_origin()
	var bottomLeft:Vector2 = Vector2(topLeft.x, topLeft.y + get_viewport_rect().size.y)
	var shockwavePos:Vector2 = (global_position - bottomLeft) / get_viewport_rect().size
	shockwavePos.x = abs(shockwavePos.x)
	shockwavePos.y = abs(shockwavePos.y)
	shockwave.material.set_shader_param("center", shockwavePos)
	screenEffectPlayer.play("Shockwave");

func flash() -> void:
	modulate.a = 0.3
	yield(get_tree().create_timer(invincibleTimer.wait_time / 4), "timeout")
	modulate.a = 1.0
	yield(get_tree().create_timer(invincibleTimer.wait_time / 4), "timeout")
	modulate.a = 0.3
	yield(get_tree().create_timer(invincibleTimer.wait_time / 4), "timeout")
	modulate.a = 1.0

func died() -> void:
	assert(_life <= 0)

func getLife() -> int:
	return _life;

# Method that can be cheked for on nodes to determine if the node is the player
# node.has_method("isPlayer") will return true, the method need not do anything
# special
func isPlayer() -> void:
	pass

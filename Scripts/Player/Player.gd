# Player

extends KinematicBody2D
class_name Player

# Movement based stuff
export var ACCELERATION:float = 100
export var MAX_SPEED:float = 100
var _velocity = Vector2(0,0)

export var MAX_LIFE:int = 6;

# Bullet based stuff
export var BULLETDAMAGE:float = 1;
var projectile:PackedScene = preload("res://Prefabs/Combat/Bullet.tscn")

export var INVINCIBLE_TIME = 0.4

onready var gunTimer:Timer = $GunTimer
onready var collisionShape:CollisionShape2D = $CollisionShape2D
onready var screenEffectPlayer:AnimationPlayer = $ScreenEffectPlayer
onready var shockwave:ColorRect = $ScreenRenderLayer/Shockwave
onready var damageable:Damageable = $Damageable

# fired when player positions changes, additionally sends out new position
signal moved()
signal _bulletCreated(newBullet)

func _ready() -> void:
	damageable.setHealth(MAX_LIFE)
	damageable.setInvincibleTime(INVINCIBLE_TIME)
	Utils.checkError(damageable.connect("died", self, "died"))
	Utils.checkError(damageable.connect("damageTaken", self, "_onDamageTaken"))

func _physics_process(_delta) -> void:
	move()
	checkCollisions()
	shoot()

# Moves the player
func move() -> void:
	if $PlayerInput.x != 0 || $PlayerInput.y != 0:
		var movement:Vector2 = Vector2($PlayerInput.x, $PlayerInput.y)
		movement = movement.normalized()
		movement *= ACCELERATION
		movement.x = clamp(movement.x, -MAX_SPEED, MAX_SPEED)
		movement.y = clamp(movement.y, -MAX_SPEED, MAX_SPEED)
		_velocity = move_and_slide(movement, Vector2.UP)
		emit_signal("moved", global_position)

func shoot() -> void:
	if $PlayerInput.shooting && gunTimer.is_stopped():
		createProj()

func createProj() -> void:
	gunTimer.start(PlayerStats.fireRate)
	var projInstance:Bullet = BulletManager.getBullet()
	emit_signal("_bulletCreated", projInstance)
	projInstance.setDamage(PlayerStats.damage())

	var mousePos:Vector2 = get_global_mouse_position()
	var bulletDirection:Vector2 = (mousePos - position).normalized()
	projInstance.linear_velocity = bulletDirection * PlayerStats.bulletSpeed
	projInstance.set_position(position + (bulletDirection * 25))

func checkCollisions() -> void:
	for i in get_slide_count():
		var collision:KinematicCollision2D = get_slide_collision(i);
		if collision.collider.has_method("isEnemy"):
			damageable.takeDamageInt(1)
	pass

func _onDamageTaken() -> void:
	doShockwave()
	flash()

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
	yield(get_tree().create_timer(damageable.invincibleTimer.wait_time / 4), "timeout")
	modulate.a = 1.0
	yield(get_tree().create_timer(damageable.invincibleTimer.wait_time / 4), "timeout")
	modulate.a = 0.3
	yield(get_tree().create_timer(damageable.invincibleTimer.wait_time / 4), "timeout")
	modulate.a = 1.0

func died(var _direction:Vector2) -> void:
	assert(damageable._health <= 0)

func getLife() -> int:
	return damageable._health

# Method that can be cheked for on nodes to determine if the node is the player
# node.has_method("isPlayer") will return true, the method need not do anything
# special
func isPlayer() -> void:
	pass

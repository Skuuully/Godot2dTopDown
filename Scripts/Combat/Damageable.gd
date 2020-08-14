extends Node2D
class_name Damageable

export var _health = 10
export var _invincibleTime:float = 0.01 setget setInvincibleTime

onready var invincibleTimer:Timer = $InvincibleTimer

var bullets = Array()

signal died()
signal damageTaken()

func _ready() -> void:
	invincibleTimer.wait_time = _invincibleTime

func takeDamage(var bullet:Bullet) -> void:
	if invincibleTimer.is_stopped():
		_health -= bullet.getDamage()
		if _health <= 0:
			emit_signal("died", bullet.getLastFrameLinearVelocity())
		else:
			emit_signal("damageTaken")
			invincibleTimer.start()

func takeDamageInt(var damage:int) -> void:
	if invincibleTimer.is_stopped() && _health > 0:
		_health -= damage
		emit_signal("damageTaken")
		if _health <= 0:
			emit_signal("died", Vector2(0, 0))
		else:
			invincibleTimer.start()

func setHealth(var health:int) -> void:
	_health = health;

func setInvincibleTime(time:float) -> void:
	_invincibleTime = time
	invincibleTimer.wait_time = time

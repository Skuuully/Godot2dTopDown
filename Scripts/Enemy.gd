# Enemy

extends KinematicBody2D
class_name Enemy

export var MOVE_SPEED:float = 30
export var PLAYER_TOLERANCE:Vector2 = Vector2(20, 20)
var _route = null

# Reference to the damageable node
onready var _damageable:Node2D = $Damageable

# The particles to instance on death
var _deathParticles:PackedScene = preload("res://Prefabs/EnemyDeathParticles.tscn")

signal onDeath()

func _ready() -> void:
	_damageable.connect("died", self, "_onDeath")

func _physics_process(delta) -> void:
	_followRoute(delta)
	checkCollisions()

func setRoute(newRoute) -> void:
	_route = newRoute

func _followRoute(delta) -> void:
	if (_route != null) && (_route.size() > 0):
		var dir:Vector2 = (_route[0] - global_position).normalized()
		
		if dir == Vector2.ZERO:
			_route.remove(0)
			dir = (_route[0] - global_position).normalized()

		move_and_slide(dir * MOVE_SPEED)
		
		if global_position == _route[0]:
			_route.remove(0)

# Handler for the damageables died event
# creates particles
# frees body
func _onDeath(var bullet:Bullet) -> void:
	emit_signal("onDeath", self)
	var deathParticles:CPUParticles2D = _deathParticles.instance()
	deathParticles.position = global_position;
	get_tree().get_root().add_child(deathParticles)
	deathParticles.emitting = true;
	# Rotation should be set to opposite the bullet that collided with it
	deathParticles.rotation = bullet.getLastFrameLinearVelocity().angle() + 90
	
	# After particles created and added remove enemy
	queue_free()

func checkCollisions() -> void:
	for i in get_slide_count():
		var collision:KinematicCollision2D = get_slide_collision(i);
		if collision.collider is load("res://Scripts/Player.gd") as Script:
			collision.collider.onDamageTaken()
	pass

# Method that can be cheked for on nodes to determine if the node is an enemy
# node.has_method("isEnemy") will return true, the method need not do anything
# special
func isEnemy():
	pass

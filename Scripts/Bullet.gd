# Bullet

extends RigidBody2D
class_name Bullet

signal collision()

var _lastFrameLinearVelocity = Vector2(0, 0) setget , getLastFrameLinearVelocity
# Tracks the bodies from previous frame
var _bodies

# The damage value that the bullet will hold 
var _damage setget setDamage, getDamage

var _collisionParticles = preload("res://Prefabs/BulletCollisionParticles.tscn")

var _creator:Node2D setget setCreator, getCreator

func _physics_process(_delta):
	var newBodies:Array = get_colliding_bodies()
	for body in newBodies:
		createParticles()
		if body.is_in_group("Damageable") && (_bodies != null) && !(body in _bodies):
			emit_signal("collision", self, position, body)
			queue_free()
	
	_bodies = newBodies
	_lastFrameLinearVelocity = linear_velocity

func setDamage(var dmg):
	_damage = dmg

func getDamage():
	return _damage

func getLastFrameLinearVelocity():
	return _lastFrameLinearVelocity
	
func createParticles():
	var particles = _collisionParticles.instance();
	particles.position = position
	var currAngle = _lastFrameLinearVelocity.angle() * (180 / PI)
	particles.rotation_degrees = currAngle + 180
	get_tree().get_root().add_child(particles)
	particles.emitting = true

func setCreator(creator:Node2D) -> void:
	_creator = creator

func getCreator() -> Node2D:
	return _creator

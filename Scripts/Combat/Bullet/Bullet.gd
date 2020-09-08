# Bullet

extends RigidBody2D
class_name Bullet

var _lastFrameLinearVelocity = Vector2(0, 0) setget , getLastFrameLinearVelocity

# The damage value that the bullet will hold 
var _damage setget setDamage, getDamage

var _collisionParticles = preload("res://Prefabs/Combat/BulletCollisionParticles.tscn")
var dmgText = preload("res://Prefabs/Combat/DamageText.tscn")

var _creator:Node2D setget setCreator, getCreator

func _physics_process(_delta):
	var newBodies:Array = get_colliding_bodies()
	for body in newBodies:
		createParticles()
		if body.has_node("Damageable") && (body != _creator):
			onCollision(body)
			queue_free()
		else:
			queue_free()
	
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

func onCollision(other:Node) -> void:
	var damageText = dmgText.instance()
	damageText.rect_position = position
	var displayDamage = (floor(_damage * 10) / 10)
	damageText.text = str(displayDamage)
	for node in other.get_children():
		if other.has_node("Damageable"):
			other.get_node("Damageable").takeDamage(self)
	get_tree().get_root().add_child(damageText)

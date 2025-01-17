# Bullet

extends RigidBody2D
class_name Bullet

var _lastFrameLinearVelocity = Vector2(0, 0) setget , getLastFrameLinearVelocity

# The damage value that the bullet will hold 
var _damage setget setDamage, getDamage
export var speed:int = 100

var _collisionParticles = preload("res://Prefabs/Combat/BulletCollisionParticles.tscn")
var _collisionSound = preload("res://Audio/8BitSoundPack/General Sounds/Impacts/sfx_sounds_impact6.wav")
var dmgText = preload("res://Prefabs/Combat/DamageText.tscn")

var _creator:Node2D setget setCreator, getCreator

var bulletCollisionHandler = BulletCollisionRegular.new(self)

func _ready() -> void:
	Utils.checkError(self.connect("body_entered", self, "onBodyEntered"))

func _integrate_forces(_state):
	linear_velocity = linear_velocity.normalized() * speed

func _physics_process(_delta):	
	_lastFrameLinearVelocity = linear_velocity

func freeMem() -> void:
	var audioPlayer = $MultipleAudioPlayer
	remove_child(audioPlayer)
	get_parent().add_child(audioPlayer)
	queue_free()

func setDamage(var dmg):
	_damage = dmg

func getDamage():
	return _damage

func getLastFrameLinearVelocity():
	return _lastFrameLinearVelocity
	
func createParticles():
	$MultipleAudioPlayer.play(_collisionSound)
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

func onBodyEntered(body) -> void:
	createParticles()
	if body.has_node("Damageable") && (body != _creator):
		onCollision(body)
		if bulletCollisionHandler.has_method("livingCollide"):
			bulletCollisionHandler.livingCollide()
	bulletCollisionHandler.collide()

func onCollision(other:Node) -> void:
	var damageText = dmgText.instance()
	damageText.rect_position = position
	var displayDamage = (floor(_damage * 10) / 10)
	damageText.text = str(displayDamage)
	for node in other.get_children():
		if other.has_node("Damageable"):
			other.get_node("Damageable").takeDamage(self)
	get_tree().get_root().add_child(damageText)

func changeCollisionRicochet(ricochetNum) -> void:
	bulletCollisionHandler = BulletCollisionRicochet.new(self, ricochetNum)

func changeCollisionRegular() -> void:
	bulletCollisionHandler = BulletCollisionRegular.new(self)

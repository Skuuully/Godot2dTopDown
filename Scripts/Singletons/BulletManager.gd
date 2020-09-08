# BulletManager
# Bullet object pool which additionally handles bullet collisions, publicly 
# access via getBullet and removeBullet
extends Node2D

var activeBullets = []
var unactiveBullets = []
var startingPoolSize:int = 20
var poolExpandSize:int = 10
var bulletScene = preload("res://Prefabs/Combat/Bullet.tscn")
var dmgText = preload("res://Prefabs/Combat/DamageText.tscn")

func _init() -> void:
	expandPool(startingPoolSize)

func expandPool(size:int) -> void:
	for i in size:
		addToPool(unactiveBullets)

func addToPool(pool) -> void:
	var instance = bulletScene.instance()
	pool.push_back(instance)
	Utils.checkError(instance.connect("collision", self, "onCollision"))

func getLastBullet() -> Bullet:
	var bullet = unactiveBullets.pop_back()
	activeBullets.push_back(bullet)
	add_child(bullet)
	return bullet

func getBullet() -> Bullet:
	if unactiveBullets.size() > 0:
		return getLastBullet()
	else:
		expandPool(poolExpandSize)
		return getLastBullet()

func removeBullet(bullet) -> void:
	var index = activeBullets.find(bullet)
	if index != -1:
		activeBullets.remove(index)
		unactiveBullets.push_back(bullet)
		remove_child(bullet)

func onCollision(bullet:Bullet, collisionPosition:Vector2, other:Node) -> void:
	var damageText = dmgText.instance()
	damageText.rect_position = collisionPosition
	var displayDamage = (floor(bullet.getDamage() * 10) / 10)
	damageText.text = str(displayDamage)
	for node in other.get_children():
		if other.has_node("Damageable"):
			other.get_node("Damageable").takeDamage(bullet)
	get_tree().get_root().add_child(damageText)

extends Node2D
# class_name BulletManager Singleton

var dmgText = preload("res://Prefabs/Combat/DamageText.tscn")
var _bullets = Array() setget ,getAllBullets

func getAllBullets():
	return _bullets

func addBullet(bullet:Bullet):
	_bullets.push_back(bullet)
	Utils.checkError(bullet.connect("collision", self, "_onCollision"))

func _removeBullet(bullet):
	_bullets.erase(bullet)

func _onCollision(bullet:Bullet, collisionPosition:Vector2, other:Node) -> void:
	var damageText = dmgText.instance()
	damageText.rect_position = collisionPosition
	var displayDamage = (floor(bullet.getDamage() * 10) / 10)
	damageText.text = str(displayDamage)
	for node in other.get_children():
		if other.has_node("Damageable"):
			other.get_node("Damageable").takeDamage(bullet)
	get_tree().get_root().add_child(damageText)

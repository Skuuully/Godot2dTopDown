extends Node
class_name BulletCollisionRegular

var bullet

func _init(inBullet):
	bullet = inBullet

func collide() -> void:
	bullet.freeMem()

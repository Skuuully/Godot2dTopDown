extends Node
class_name BulletCollisionRicochet

var bullet
var ricochetCount:int = 1

func _init(inBullet, inRicochetCount:int) -> void:
	bullet = inBullet
	ricochetCount = inRicochetCount

func collide() -> void:
	ricochetCount -= 1
	if ricochetCount == 0:
		bullet.changeCollisionRegular()

func livingCollide() -> void:
	bullet.freeMem()

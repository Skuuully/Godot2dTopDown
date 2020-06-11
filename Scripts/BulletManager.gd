# Bullet Manager

extends Node2D

var _bullets = Array() setget ,getAllBullets

func getAllBullets():
	return _bullets

func addBullet(bullet):
	_bullets.push_back(bullet)

func _removeBullet(bullet):
	_bullets.erase(bullet)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

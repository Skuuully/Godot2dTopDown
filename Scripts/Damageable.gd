# Damageable

extends Node2D

export var _health = 10

var bullets = Array()

signal died()

func takeDamage(var bullet):
	_health -= bullet.getDamage()
	if _health <= 0:
		emit_signal("died", bullet)



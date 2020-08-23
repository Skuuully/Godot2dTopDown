extends Node

var damageBase = 1.0
var damageMultiplier = 1.0
var bulletSpeed = 150
var fireRate = 0.2

func damage() -> float:
	return damageBase * damageMultiplier;

extends Node

var damageMin = 0.8
var damageMax = 1.2
var damageMultiplier = 1.0
var bulletSpeed = 150
var fireRate = 0.2

var rand = RandomNumberGenerator.new()

func damage() -> float:
	return rand.randf_range(damageMin, damageMax) * damageMultiplier;

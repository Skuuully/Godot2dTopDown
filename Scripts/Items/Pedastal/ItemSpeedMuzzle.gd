extends Item
class_name ItemSpeedMuzzle

func _init() -> void:
	texture = preload("res://Sprites/PedastalItems/ReinforcedChamber.png")
	flavourText = "Muzzle go fast"
	tier = 1

func do() -> void:
	.do()
	PlayerStats.fireRate -= 0.01


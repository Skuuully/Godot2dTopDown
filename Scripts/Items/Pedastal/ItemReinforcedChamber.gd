extends Item
class_name ItemReinforcedChamber

func _init() -> void:
	texture = preload("res://Sprites/PedastalItems/ReinforcedChamber.png")
	flavourText = "Reinforces the chamber"
	tier = 1

func do() -> void:
	.do()
	PlayerStats.damageMultiplier += 0.2


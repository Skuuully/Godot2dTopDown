extends Item
class_name ItemReinforcedChamber

func _init() -> void:
	texture = preload("res://Sprites/PedastalItems/ReinforcedChamber.png")

func flavourText() -> String:
	return "Reinforces the chamber"

func do() -> void:
	.do()
	PlayerStats.damageMultiplier += 0.2

func id() -> String:
	return "Reinforced Chamber"


extends Item
class_name ItemReinforcedChamber

func flavourText() -> String:
	return "Reinforces the chamber"

func do() -> void:
	PlayerStats.damageMultiplier += 0.2

func id() -> String:
	return "Reinforced Chamber"


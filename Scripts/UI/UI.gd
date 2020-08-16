extends Control

onready var nonCombat = $CanvasLayer/NonCombat
onready var _lifeBar:TextureProgress = $CanvasLayer/Combat/Margin/HBoxContainer/TextureProgress

func _ready():
	_lifeBar.set_value(100)

func updateLife(currentHealth:int, maxHealth:int) -> void:
	var percentage:float = (currentHealth as float/maxHealth as float) * 100.0
	_lifeBar.set_value(percentage)

func hideNonCombat() -> void:
	nonCombat.hide()

func showNonCombat() -> void:
	nonCombat.show()

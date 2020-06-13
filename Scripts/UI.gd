extends Control

onready var _lifeBar:TextureProgress = $CanvasLayer/Margin/HBoxContainer/TextureProgress

func _ready():
	_lifeBar.set_value(100)

func updateLife(currentHealth:int, maxHealth:int) -> void:
	var percentage:float = (currentHealth as float/maxHealth as float) * 100.0
	_lifeBar.set_value(percentage)

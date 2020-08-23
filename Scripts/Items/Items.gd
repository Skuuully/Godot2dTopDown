extends Node

# String to Item
var allItems = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	var reinforcedChamber:ItemReinforcedChamber = ItemReinforcedChamber.new()
	allItems[reinforcedChamber.id()] = reinforcedChamber
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

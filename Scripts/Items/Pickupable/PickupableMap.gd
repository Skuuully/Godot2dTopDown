extends Node

var mapData:MapData
onready var sprite = $Sprite
onready var pickupable = $PickupableItem

func _ready() -> void:
	sprite.texture = mapData.texture
	Utils.checkError(pickupable.connect("pickedUp", self, "onPickup"))

func onPickup() -> void:
	var canpickup = (GlobalNodes.getGUIMapInventory() as MapInventory).addRoom(mapData)
	if canpickup:
		pickupable.queue_free()
		queue_free()

extends Node

var mapData:MapData
onready var typeIcon = $TypeIcon
onready var roomBorder = $RoomBorder
onready var pickupable = $PickupableItem

func _ready() -> void:
	typeIcon.texture = mapData.texture
	typeIcon.modulate = mapData.borderColour
	roomBorder.texture = mapData.borderTexture
	roomBorder.modulate = mapData.borderColour
	Utils.checkError(pickupable.connect("pickedUp", self, "onPickup"))

func onPickup() -> void:
	var canpickup = PlayerInventory.getMapInventory().canAddMap()
	if canpickup:
		PlayerInventory.getMapInventory().addMap(mapData)
		pickupable.queue_free()
		queue_free()

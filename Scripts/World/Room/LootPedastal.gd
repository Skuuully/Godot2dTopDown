extends Node2D

onready var collisionArea = $CollisionArea
onready var lootSprite = $LootSprite
var item:Item = null

func _ready():
	generateLootItem()
	Utils.checkError(collisionArea.connect("body_entered", self, "onBodyEntered"))

func generateLootItem() -> void:
	item = ItemReinforcedChamber.new()
	lootSprite.texture = item.texture

func onBodyEntered(body) -> void:
	if item != null && body.has_method("isPlayer"):
		itemPickedUp()

func itemPickedUp() -> void:
	PlayerInventory.add(item)
	item = null
	lootSprite.texture = null

extends Node2D

onready var collisionArea = $CollisionArea
onready var lootSprite = $LootSprite
var item:Item = null

var bobbingUp:bool = false

func _ready():
	generateLootItem()
	Utils.checkError(collisionArea.connect("body_entered", self, "onBodyEntered"))
	itemBob()
	Utils.checkError($Tween.connect("tween_completed", self, "onBobFinished"))

func generateLootItem() -> void:
	item = ItemReinforcedChamber.new()
	lootSprite.texture = item.texture

func onBodyEntered(body) -> void:
	if item != null && body.has_method("isPlayer"):
		itemPickedUp()

func itemPickedUp() -> void:
	GlobalNodes.getGUIMap().clearCurrentRoomIcon()
	$MultipleAudioPlayer.play(preload("res://Audio/8BitSoundPack/General Sounds/Positive Sounds/sfx_sounds_powerup15.wav"))
	PlayerInventory.addItem(item)
	item = null
	lootSprite.texture = null

func itemBob() -> void:
	var bottom = lootSprite.position.y - 20
	var top = lootSprite.position.y + 20
	var endPos:float = top if bobbingUp else bottom
	$Tween.interpolate_property(lootSprite, "position:y",
	lootSprite.position.y, endPos, 0.75, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	bobbingUp = !bobbingUp
	$Tween.start()

func onBobFinished(_arg1, _arg2) -> void:
	itemBob()

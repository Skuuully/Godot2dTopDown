extends TextureRect
class_name InventoryRoom

var scene:PackedScene = null
var mouseOver:bool = false
enum type {EMPTY, ENEMY, LOOT}

func _init(inScene:PackedScene, inTexture:Texture) -> void:
	self.scene = inScene
	self.texture = inTexture

func _ready():
	Utils.checkError(self.connect("mouse_entered", self, "mouseEntered"))
	Utils.checkError(self.connect("mouse_exited", self, "mouseExited"))

func mouseEntered() -> void:
	mouseOver = true
	modulate.a = 0.5

func mouseExited() -> void:
	mouseOver = false
	modulate.a = 1

func _input(event) -> void:
	if mouseOver && event.is_action("lmb"):
		MouseData.setData(self)
		get_parent().remove_child(self)

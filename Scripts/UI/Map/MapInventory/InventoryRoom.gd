extends TextureRect
class_name InventoryRoom

onready var border = $Border

var mapData:MapData
var mouseOver:bool = false

func _ready():
	Utils.checkError(self.connect("mouse_entered", self, "mouseEntered"))
	Utils.checkError(self.connect("mouse_exited", self, "mouseExited"))
	
	texture = mapData.texture
	modulate = mapData.borderColour
	border.texture = mapData.borderTexture
	border.modulate = mapData.borderColour

func mouseEntered() -> void:
	mouseOver = true
	modulate.a = 0.5

func mouseExited() -> void:
	mouseOver = false
	modulate.a = 1

func get_drag_data(_position):
	var rect:ColorRect = ColorRect.new()
	rect.rect_size = Vector2(30, 30)
	set_drag_preview(rect)
	return self

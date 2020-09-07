extends TextureRect
class_name InventoryRoom

var mapData:MapData
var mouseOver:bool = false

func _init(inMapData:MapData) -> void:
	mapData = inMapData
	texture = mapData.texture
	
	# Temp, allows icons to look different to test correct one being removed on place
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	modulate.r = rng.randf_range(0, 10) / 10.0
	modulate.g = rng.randf_range(0, 10) / 10.0
	modulate.b = rng.randf_range(0, 10) / 10.0

func _ready():
	Utils.checkError(self.connect("mouse_entered", self, "mouseEntered"))
	Utils.checkError(self.connect("mouse_exited", self, "mouseExited"))

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

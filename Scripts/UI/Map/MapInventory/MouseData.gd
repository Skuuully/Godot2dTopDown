extends Control

var data:InventoryRoom = null setget setData
var display:TextureRect = TextureRect.new()

func _ready():
	add_child(display)

func _process(_delta):
	if data != null:
		display.rect_position = get_global_mouse_position()

func setData(inData) -> void:
	if inData == null:
		data = inData
		display.texture = null
	else:
		data = inData
		display.texture = data.texture

func _input(event) -> void:
	if event.is_action_released("lmb"):
		setData(null)

# Allows the map to be pannable and clip the content to itself
tool
extends Control

onready var mapContainer = $MapContainer
var oldMousePos:Vector2 = Vector2(0, 0)

func _ready() -> void:
	rect_clip_content = true

func _input(event:InputEvent) -> void:
	if event is InputEventMouseMotion && Input.is_action_pressed("rmb"):
		var movement:Vector2 = (get_global_mouse_position() - oldMousePos)
		mapContainer.rect_position += movement
		# pan the map

	oldMousePos = get_global_mouse_position()

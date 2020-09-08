# Allows the map to be pannable and clip the content to itself
tool
extends Control

onready var mapContainer = $MapContainer
var oldMousePos:Vector2 = Vector2(0, 0)
var zoomInCap:Vector2 = Vector2(0.2, 0.2)
var zoomOutCap:Vector2 = Vector2(2.0, 2.0)

func _ready() -> void:
	rect_clip_content = true

func _input(event:InputEvent) -> void:
	if event is InputEventMouseMotion && Input.is_action_pressed("rmb"):
		var movement:Vector2 = (get_global_mouse_position() - oldMousePos)
		mapContainer.rect_position += movement
		
	var scrollUp = event.get_action_strength("ScrollUp")
	if (scrollUp > 0) && mapContainer.rect_scale < zoomOutCap:
		mapContainer.rect_scale += Vector2(0.05, 0.05)
		
	var scrollDown = event.get_action_strength("ScrollDown")
	if (scrollDown > 0 && mapContainer.rect_scale > zoomInCap):
		mapContainer.rect_scale -= Vector2(0.05, 0.05)
	
	oldMousePos = get_global_mouse_position()

# PickupableItem
# Attach as a child to another node, and connect to the pickedUp signal
# fired when the player enters
extends Node2D

signal pickedUp()

export(Vector2) var extents = Vector2(10, 10) setget setExtents
onready var area = $Area2D

func _ready() -> void:
	Utils.checkError(area.connect("body_entered", self, "onBodyEntered"))

func onBodyEntered(body) -> void:
	if body.has_method("isPlayer"):
		emit_signal("pickedUp")

func setExtents(inExtents:Vector2) -> void:
	extents = inExtents
	if $Area2D/CollisionShape2D != null:
		$Area2D/CollisionShape2D.shape.set_extents(extents)

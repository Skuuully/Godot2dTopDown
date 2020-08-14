# Small class to hold multiple doors so that it is easier to call methods on
# all doors from within a room
extends Node2D
class_name Doors

var doors:Array = []

func _ready() -> void:
	for child in get_children():
		if child is Door:
			doors.push_back(child)

func open() -> void:
	for door in doors:
		if door is Door:
			var d:Door = door as Door
			d.open()

func close() -> void:
	for door in doors:
		if door is Door:
			var d:Door = door as Door
			d.close()

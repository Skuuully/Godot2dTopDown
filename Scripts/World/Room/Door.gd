# Door
extends Node2D
class_name Door

export(Texture) var textureOpen:Texture = preload("res://Sprites/Environment/DoorOpen.png")
export(Texture) var textureClosed:Texture = preload("res://Sprites/Environment/DoorClosed.png")

var isOpen:bool = false
var pairedDoor = null

onready var sprite = $Sprite
onready var exitArea = $ExitArea
onready var entryPosition:Position2D = $EntryPosition

enum doorFacing {UP, DOWN, LEFT, RIGHT}
export(doorFacing) var doorDirection = doorFacing.UP

func _ready():
	sprite.texture = textureClosed
	exitArea.connect("body_entered", self, "_onBodyEnter")
	GlobalNodes.getWorldMap().connect("roomAdded", self, "_onRoomAdded")
	pass

func open() -> void:
	if !isOpen && pairedDoor != null:
		sprite.texture = textureOpen
		isOpen = true

func close() -> void:
	if isOpen:
		sprite.texture = textureClosed
		isOpen = false

func _onBodyEnter(body) -> void:
	if isOpen && (body is Player):
		teleportPlayer()

# @param _instance the room that was added
func _onRoomAdded(_instance) -> void:
	if pairedDoor == null:
		var adjacentRoom = getAdjacentRoom()
		if adjacentRoom != null:
			setupExitLocation(adjacentRoom)

func getAdjacentRoom() -> Node:
	var room = get_parent().get_parent()
	var adjacentPosition:Vector2 = room.gridPosition
	match doorDirection:
		doorFacing.UP:
			adjacentPosition.y -= 1
		doorFacing.DOWN:
			adjacentPosition.y += 1
		doorFacing.LEFT:
			adjacentPosition.x -= 1 
		doorFacing.RIGHT:
			adjacentPosition.x += 1
	var worldMap = GlobalNodes.getWorldMap()
	return worldMap.placedMap.get(adjacentPosition)
	
func setupExitLocation(adjacentRoom:Node) -> void:
	for door in adjacentRoom.doors.get_children():
		var oppositeDir = door.doorDirection
		match doorDirection:
			doorFacing.UP:
				if oppositeDir == doorFacing.DOWN:
					pairedDoor = door
					break
			doorFacing.DOWN:
				if oppositeDir == doorFacing.UP:
					pairedDoor = door
					break
			doorFacing.LEFT:
				if oppositeDir == doorFacing.RIGHT:
					pairedDoor = door
					break
			doorFacing.RIGHT:
				if oppositeDir == doorFacing.LEFT:
					pairedDoor = door
					break
	
	if pairedDoor != null:
		open()

func teleportPlayer() -> void:
	GlobalNodes.getPlayer().global_position = pairedDoor.entryPosition.global_position
	pairedDoor.get_parent().get_parent().activate()
	pass

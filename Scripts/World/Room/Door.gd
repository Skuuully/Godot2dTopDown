# Door
tool
extends Node2D
class_name Door

export(Texture) var textureOpen:Texture = preload("res://Sprites/Environment/DoorOpen.png")
export(Texture) var textureClosed:Texture = preload("res://Sprites/Environment/DoorClosed.png")

var isOpen:bool = false
var pairedDoor = null

onready var sprite = $Sprite
onready var exitArea = $ExitArea
onready var collisionShape:CollisionShape2D = $CollisionArea/CollisionShape2D
onready var exitShape:CollisionShape2D = $CollisionArea/CollisionShape2D
onready var entryPosition:Position2D = $EntryPosition
onready var audioPlayer:MultipleAudioPlayer = $MultipleAudioPlayer

enum doorFacing {UP, DOWN, LEFT, RIGHT}
export(doorFacing) var doorDirection = doorFacing.UP setget setDoorFacing

func _ready():
	sprite.texture = textureClosed
	exitArea.connect("body_entered", self, "_onBodyEnter")
	Utils.checkError(GlobalNodes.getWorldMap().connect("roomAdded", self, "_onRoomAdded"))
	pass

func open() -> void:
	if !isOpen && pairedDoor != null:
		audioPlayer.play(preload("res://Audio/Door/qubodup-DoorOpen01.ogg"))
		sprite.texture = textureOpen
		isOpen = true
		collisionShape.set_deferred("disabled", true)

func close() -> void:
	if isOpen:
		audioPlayer.play(preload("res://Audio/Door/qubodup-DoorClose01.ogg"))
		sprite.texture = textureClosed
		isOpen = false
		collisionShape.set_deferred("disabled", false)

func _onBodyEnter(body) -> void:
	if isOpen && (body is Player):
		teleportPlayer()

# @param _instance the room that was added
func _onRoomAdded(_instance) -> void:
	if pairedDoor == null:
		var adjacentRoom = getAdjacentRoom()
		if adjacentRoom != null:
			setupPairedDoor(adjacentRoom)

func getAdjacentRoom() -> Node:
	var room = get_parent().get_parent()
	var adjacentPosition:Vector2 = room.gridPosition
	match doorDirection:
		doorFacing.UP:
			adjacentPosition.x -= 1
		doorFacing.DOWN:
			adjacentPosition.x += 1
		doorFacing.LEFT:
			adjacentPosition.y -= 1 
		doorFacing.RIGHT:
			adjacentPosition.y += 1
	var worldMap = GlobalNodes.getWorldMap()
	return worldMap.placedMap.get(adjacentPosition)
	
func setupPairedDoor(adjacentRoom:Node) -> void:
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
		if pairedDoor.pairedDoor == null:
			pairedDoor.pairedDoor = self
			pairedDoor.open()

# SFI: Would be nice to play some screen wide animation that hides the screen 
# then redisplays once the player is in the room
func teleportPlayer() -> void:
	var player = GlobalNodes.getPlayer()
	var entryPos = pairedDoor.entryPosition.global_position
	var vec = player.global_position - entryPos
	player.global_position = entryPos + vec/2
	yield(get_tree().create_timer(0.1), "timeout")
	player.global_position = entryPos

# setter for doorFacing, allows changing value in editor to reflect in the room
# instantly
func setDoorFacing(newDoorDirection) -> void:
	doorDirection = newDoorDirection 
	match(doorDirection):
		doorFacing.UP:
			rotation_degrees = 0
		doorFacing.DOWN:
			rotation_degrees = 180
		doorFacing.LEFT:
			rotation_degrees = -90
		doorFacing.RIGHT:
			rotation_degrees = 90

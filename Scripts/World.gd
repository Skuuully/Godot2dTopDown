# World

extends Node2D

# The player node
onready var player = $Player

# The player camera, used when no room is currently active
onready var _playerCamera = $PlayerCamera

# The bullet manager
onready var _bulletManager = $BulletManager

# The currently active room
onready var _activeRoom = $StartRoom

# The text to instantiate when a bullet collides
var dmgText = preload("res://Prefabs/DamageText.tscn")

func _ready():
	player.connect("_bulletCreated", self, "_onBulletCreated")
	player.connect("moved", self, "_onPlayerMove")
	for child in get_children():
		if (child != null) && child.has_method("isRoom"):
			child.connect("playerExited", self, "_playerExited")
			child.connect("playerEntered", self, "_playerEntered")
	
	_activeRoom.activateCamera()

func _onCollision(bullet, collisionPosition, other):
	var damageText = dmgText.instance()
	get_tree().get_root().add_child(damageText)
	damageText.rect_position = collisionPosition
	damageText.text = str(bullet.getDamage())
	for node in other.get_children():
		if node.has_method("takeDamage"):
			node.takeDamage(bullet)

# Handler for when bullets are created
func _onBulletCreated(newBullet):
	_bulletManager.addBullet(newBullet)
	newBullet.connect("collision", self, "_onCollision")

# Handler for when the player moves
func _onPlayerMove(playerPosition):
	# Inform the active room of the player position
	_activeRoom.playerMoved(playerPosition)
	_playerCamera.playerMoved(playerPosition)

func getAllBullets():
	return _bulletManager.getAllBullets()

func _playerExited():
	_playerCamera.activateCamera(_activeRoom.getCameraPosition())
	pass

func _playerEntered(newRoom):
	_activeRoom = newRoom
	_activeRoom.activateCamera()
	pass

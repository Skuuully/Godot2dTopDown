extends KinematicBody2D
class_name FollowPlayerEnemy

signal died()

onready var stateMachine = $StateMachine
var _targetPosition
var active:bool = false setget setActive

onready var damageable = $Damageable

# The particles to instance on death
var _deathParticles:PackedScene = preload("res://Prefabs/Combat/EnemyDeathParticles.tscn")

func _ready() -> void:
	 Utils.checkError(damageable.connect("died", self, "_onDeath"))

func _physics_process(_delta):
	checkCollisions()

func setPlayerPosition(var playerPosition:Vector2) -> void:
	_targetPosition = playerPosition
	stateMachine.playerMoved(playerPosition)
	pass

# Return - A route to get to a point within  
func getRouteToPlayer():
	var route = null
	
	var parent = get_parent()
	if parent != null && parent is Room && (_targetPosition != null):
		var room:Room = parent as Room
		
		route = room.getRouteToPlayer(position)
	
	return route

func _onDeath(direction:Vector2) -> void:
	emit_signal("died", self)
	var deathParticles:CPUParticles2D = _deathParticles.instance()
	deathParticles.position = global_position;
	get_tree().get_root().add_child(deathParticles)
	deathParticles.emitting = true;
	# Rotation should be set to opposite the bullet that collided with it
	deathParticles.rotation = direction.angle() + 90
	
	queue_free()

func setActive(newActive:bool) -> void:
	if active != newActive:
		active = newActive
		stateMachine.changeState(stateMachine.State.IDLE)

func checkCollisions() -> void:
	for i in get_slide_count():
		var collision:KinematicCollision2D = get_slide_collision(i);
		if collision.collider.has_method("isPlayer"):
			collision.collider.damageable.takeDamageInt(1)

# Method that can be cheked for on nodes to determine if the node is an enemy
# node.has_method("isEnemy") will return true, the method need not do anything
# special
func isEnemy():
	pass

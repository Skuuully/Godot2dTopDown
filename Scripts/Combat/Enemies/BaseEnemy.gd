extends Node2D
class_name BaseEnemy

# A enemy will always have:
# White flash to indicate damage taken
# Life
# A death
# The position of the player
# A collision hit box, both for receiving damage and colliding with the player

signal died()

onready var damageable = $Damageable
onready var kinematic = self

var playerPosition:Vector2 setget setPlayerPosition

func _ready() -> void:
	 Utils.checkError(damageable.connect("died", self, "onDeath"))
	 Utils.checkError(damageable.connect("damageTaken", self, "onDamageTaken"))

func _physics_process(_delta) -> void:
	checkCollisions()

func setPlayerPosition(value:Vector2) -> void:
	playerPosition = value

func onDeath(direction:Vector2) -> void:
	emit_signal("died", self)
	createParticles(direction)
	queue_free()

func createParticles(direction:Vector2) -> void:
	var deathParticles:CPUParticles2D = preload("res://Prefabs/Combat/EnemyDeathParticles.tscn").instance()
	deathParticles.position = global_position
	get_tree().get_root().add_child(deathParticles)
	deathParticles.emitting = true;
	# Rotation should be set to opposite the bullet that collided with it
	deathParticles.rotation = direction.angle() + 90

func onDamageTaken() -> void:
	$AnimationPlayer.play("whiteFlash")

func checkCollisions() -> void:
	for i in kinematic.get_slide_count():
			var collision:KinematicCollision2D = kinematic.get_slide_collision(i);
			if collision.collider != null && collision.collider.has_method("isPlayer"):
				collision.collider.damageable.takeDamageInt(1)

# Method exists to be able to check that a node is an enemy by checking for this
# method, godot is funny with circular dependencies at times
func isEnemy() -> void:
	pass

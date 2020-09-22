extends Node2D
class_name SpawnCircle

onready var animationPlayer = $AnimationPlayer
onready var finishedParticles = $CPUParticles2D

var enemy:PackedScene setget setEnemy
var enemiesNode
var enemyInstance

func setEnemy(inEnemy, inEnemiesNode = null) -> void:
	enemy = inEnemy
	enemyInstance = enemy.instance()
	enemyInstance.position = position
	enemiesNode = inEnemiesNode
	if enemiesNode != null:
		 enemiesNode.addEnemy(enemyInstance)
	enemyInstance.visible = false
	play()

func play() -> void:
	animationPlayer.play()
	animationPlayer.connect("animation_finished", self, "onAnimationFinished")

func onAnimationFinished() -> void:
	animationPlayer.queue_free()
	enemyInstance.visible = true
	finishedParticles.restart()

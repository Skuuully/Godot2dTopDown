# Enemies
# Stores all the enemies for a room, supports adding enemies to it as well as
# methods that are to be applied to all enemies.
extends Node2D
class_name Enemies

signal enemiesDefeated()

var enemies:Array = []

func addEnemy(enemy) -> void:
	enemies.push_back(enemy)
	enemy.connect("died", self, "onEnemyDeath")
	call_deferred("add_child", enemy)

func onEnemyDeath(enemy) -> void:
	var index = enemies.find(enemy)
	if index != -1:
		enemies.remove(index)
	if enemies.size() <= 0:
		emit_signal("enemiesDefeated")

func updatePlayerPosition(inPosition) -> void:
	for enemy in enemies:
		if enemy.has_method("setPlayerPosition"):
			enemy.setPlayerPosition(inPosition)

func activateEnemies(activate:bool) -> void:
	for enemy in enemies:
		if enemy.has_method("setActive"):
			enemy.setActive(activate)

func hasEnemies() -> bool:
	return enemies.size() > 0


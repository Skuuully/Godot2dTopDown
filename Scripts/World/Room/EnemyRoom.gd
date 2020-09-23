extends Room
class_name EnemyRoom

onready var enemies = $Enemies
onready var enemySpawn = $EnemySpawnSystem
onready var lootSpawn = $LootSpawn

func _ready() -> void:
	if enemies != null:
		Utils.checkError(enemies.connect("enemiesDefeated", self, "roomCleared"))

func playerMoved(inPosition) -> void:
	.playerMoved(inPosition)
	if enemies != null:
		enemies.updatePlayerPosition(inPosition)

func _bodyEntered(body) -> void:
	._bodyEntered(body)
	if body.has_method("isPlayer") && enemySpawn != null:
		enemySpawn.spawnEnemies(tier)
		activate()

func activate() -> void:
	.activate()
	if enemies != null && enemies.hasEnemies():
		GlobalNodes.getGUI().hideNonCombat()
		doors.close()
		enemies.activateEnemies(true)

func deactivate() -> void:
	if enemies != null:
		enemies.activateEnemies(false)

func roomCleared() -> void:
	GlobalNodes.getGUIMap().clearCurrentRoomIcon()
	doors.open()
	GlobalNodes.getGUI().showNonCombat()
	lootSpawn.spawnLoot(tier)

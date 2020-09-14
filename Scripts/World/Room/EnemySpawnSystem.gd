# EnemySpawnSystem
# Hosts logic for spawning the enemies, requires an enemies node to add the enemies to
tool
extends Node2D

# Should be export(Array, EnemySpawnConfig) but not allowed
export(Array, Resource) var enemySpawnConfigs:Array = [] setget setEnemySpawnConfigs
var tier1Configs:Array = []
var tier2Configs:Array = []
var tier3Configs:Array = []

export(NodePath) var enemiesNodePath = null
onready var enemiesNode:Enemies = get_node(enemiesNodePath)

var hasSpawned:bool = false

func setEnemySpawnConfigs(configs) -> void:
	clearEditorData()
	enemySpawnConfigs = configs
	for config in configs:
		if config != null:
			addToConfig(config)
			for enemySpawn in config.enemySpawns:
				if enemySpawn != null:
					var pos = Position2D.new()
					pos.position = enemySpawn.position
					add_child(pos)

func addToConfig(config) -> void:
	match(config.tier):
		1:
			tier1Configs.push_back(config)
		2:
			tier2Configs.push_back(config)
		3:
			tier3Configs.push_back(config)

func clearEditorData() -> void:
	for child in get_children():
		if child is Position2D:
			remove_child(child)
	tier1Configs.clear()
	tier2Configs.clear()
	tier3Configs.clear()

func getRandomConfig(tier:int) -> EnemySpawnConfig:
	var configArray
	match(tier):
		1:
			configArray = tier1Configs
		2:
			configArray = tier2Configs
		3:
			configArray = tier3Configs
	
	var config = null
	if configArray.size() > 0:
		randomize()
		var rand = randi() % (configArray.size())
		config = configArray[rand]
	else:
		printerr("No configs set")
		print_stack()

	return config

func spawnEnemies(tier:int) -> void:
	if !hasSpawned:
		hasSpawned = true
		var config:EnemySpawnConfig = getRandomConfig(tier)
		for enemySpawn in config.enemySpawns:
			enemySpawn = enemySpawn as EnemySpawn
			var enemy = enemySpawn.scene.instance()
			enemy.position = enemySpawn.position
			enemiesNode.addEnemy(enemy)

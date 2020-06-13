extends Node
class_name BasicEnemyState

var _stateMachine:BasicEnemyStateMachine = get_parent()

# Should handle any functionality that should occur within the _physics_process
func update() -> void:
	# Empty provide implementation in extending nodes
	pass

# Handle any functionality that may need to occur upon first entering the state
func enter() -> void:
	# Empty provide implementation in extending nodes
	pass

# Handle any functionality that should occur just before leaving the state
func _exit() -> void:
	# Empty provide implementation in extending nodes
	pass

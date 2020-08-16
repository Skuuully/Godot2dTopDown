extends Node
class_name EnemyStateMachine

# This is a class that shows a blueprint that stae machines should implement

# Some states that are available to the machine
# enum State {IDLE, MOVING, SHOOTING}

# Something to keep track of the current state, states are represented as nodes
#onready var currentState = $Idle

# Call current states update method to allow it to do whatever it needs
#func _physics_process(_delta:float) -> void:
#	currentState.update()

# Changes the state from one to another calling the entry and exit methods 
# appropiately
#func changeState(newState:int) -> void:
#	if currentState.has_method("exit"):
#		currentState.exit()

#	match newState:
#		State.IDLE:
#			currentState = idleState
#			stateDebugText.text = "Idle"
#		State.MOVING:
#			currentState = movingState
#			stateDebugText.text = "Moving"
#		State.SHOOTING:
#			currentState = shootingState
#			stateDebugText.text = "Shooting"

#	if currentState.has_method("enter"):
#		currentState.enter()

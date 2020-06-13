extends Node
class_name BasicEnemyStateMachine

# Different states for the state machine
enum State {IDLE, MOVING, SHOOTING}

# The currentStaet of the node, default to idle
onready var currentState:BasicEnemyState = $Idle

# Node for the idle state
onready var idleState = $Idle

# Node for the moving state
onready var movingState = $Moving

# Node for the shooting state
onready var shootingState = $Shooting

func _physics_process(delta:float) -> void:
	currentState.update()

# Changes the state from one to another calling the entry and exit methods 
# appropiately
func changeState(newState:int) -> void:
	currentState.exit()
	match newState:
		State.IDLE:
			currentState = idleState
		State.MOVING:
			currentState = movingState
		State.SHOOTING:
			currentState = shootingState

	currentState.enter()


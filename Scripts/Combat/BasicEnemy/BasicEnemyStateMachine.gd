extends Node
class_name BasicEnemyStateMachine

# Different states for the state machine
enum State {IDLE, MOVING, SHOOTING}

# The base enemy class
var baseEnemy = get_parent()

# The currentState of the node, default to idle
# The state will be of type BasicEnemyState, not statically typed to avoid
# cyclic dependancy
onready var currentState = $Idle

# Node for the idle state
onready var idleState = $Idle

# Node for the moving state
onready var movingState = $Moving

# Node for the shooting state
onready var shootingState = $Shooting

onready var stateDebugText = $StateDisplay

var route = null;

func _ready() -> void:
	stateDebugText.text = "Idle"

func _physics_process(_delta:float) -> void:
	currentState.update()

# Changes the state from one to another calling the entry and exit methods 
# appropiately
func changeState(newState:int) -> void:
	if currentState.has_method("exit"):
		currentState.exit()

	match newState:
		State.IDLE:
			currentState = idleState
			stateDebugText.text = "Idle"
		State.MOVING:
			currentState = movingState
			stateDebugText.text = "Moving"
		State.SHOOTING:
			currentState = shootingState
			stateDebugText.text = "Shooting"

	if currentState.has_method("enter"):
		currentState.enter()

func playerMoved(var playerPos:Vector2) -> void:
	if currentState.has_method("playerMoved"):
		currentState.playerMoved()
	pass

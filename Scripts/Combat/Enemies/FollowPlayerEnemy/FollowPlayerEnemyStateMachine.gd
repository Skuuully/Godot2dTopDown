extends EnemyStateMachine
class_name FollowPlayerEnemyStateMachine

enum State {IDLE, FOLLOW, WAIT}

onready var currentState = $Idle
onready var idleState = $Idle
onready var followState = $Follow
onready var waitState = $Wait
onready var stateDebugText = $StateDisplay

func _physics_process(_delta:float) -> void:
	currentState.update()

func changeState(newState:int) -> void:
	if currentState.has_method("exit"):
		currentState.exit()

	match newState:
		State.IDLE:
			currentState = idleState
			stateDebugText.text = "Idle"
		State.FOLLOW:
			currentState = followState
			stateDebugText.text = "Following"
		State.WAIT:
			currentState = waitState
			stateDebugText.text = "Waiting"

	if currentState.has_method("enter"):
		currentState.enter()

func playerMoved(var _playerPos:Vector2) -> void:
	if currentState.has_method("playerMoved"):
		currentState.playerMoved()


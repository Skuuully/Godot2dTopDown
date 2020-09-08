extends Node2D

var shooting:bool
var x:float
var y:float

func _unhandled_input(event):
	shooting = event.get_action_strength("lmb") > 0
	x = Input.get_action_strength("right") - Input.get_action_strength("left")
	y = Input.get_action_strength("down") - Input.get_action_strength("up")

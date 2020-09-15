extends Node


var bulletScene = preload("res://Prefabs/Combat/Bullet.tscn")

var CONNECT_ERROR:String = "Connection failed to connect"

func checkError(error:int) -> void:
	if error != OK:
		print(CONNECT_ERROR)
		print("Error type: " + str(error))
		print_stack()

func getAllChildren(node:Node) -> Array:
	var children:Array = []
	for child in node.get_children():
		children.push_back(child)
		if child.get_child_count() > 0:
			children += getAllChildren(child)
	
	return children

# Gets a random int value within the range of minValue to maxValue as either a
# positive or negative number
func randPosMin(minValue, maxValue) -> int:
	randomize()
	var randRange = maxValue - minValue + 1
	var value = (randi() % randRange) + minValue
	if randBool():
		value *= -1
	
	return value

func randBool() -> bool:
	randomize()
	return randi() % 2 == 0


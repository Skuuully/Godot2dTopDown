extends Node


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

extends Node


var CONNECT_ERROR:String = "Connection failed to connect"

func checkError(error:int) -> void:
	if error != OK:
		print(CONNECT_ERROR)
		print("Error type: " + str(error))
		print_stack()

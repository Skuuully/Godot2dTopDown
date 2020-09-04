extends Control

onready var container = $MapDrawTo/MapContainer

func connectToMapElements(obj) -> void:
	# Bad arbitrary wait, just ensures that the map elements are set up before
	# attempting to connect to the signal
	yield(get_tree().create_timer(0.2), "timeout")
	for element in container.mapElements.values():
		Utils.checkError(element.connect("roomPlaced", obj, "onRoomPlaced"))

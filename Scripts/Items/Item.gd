extends Node
class_name Item


export(Texture) var texture

func do() -> void:
	# Should do something up damage/ health/ whatever
	pass

func flavourText() -> String:
	return "No flavour given"

func id() -> String:
	return "none"

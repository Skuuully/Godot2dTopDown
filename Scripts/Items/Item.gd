extends Node
class_name Item

export(Texture) var texture
var hideableControl:HideableControl
var label

func _init() -> void:
	hideableControl = preload("res://Prefabs/HideableControl.tscn").instance()
	add_child(hideableControl)
	label = Label.new()
	add_child(label)
	label.text = flavourText()
	label.rect_position = Vector2(200, 200)

# Extending classes should do something up damage/ health/ whatever
func do() -> void:
	display()

func flavourText() -> String:
	return "No flavour given"

func id() -> String:
	return "none"

func display() -> void:
	Utils.addToTreeRoot(self)
	hideableControl.show()
	yield(get_tree().create_timer(hideableControl.showTime), "timeout")
	hideableControl.hide()

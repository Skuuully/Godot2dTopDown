extends Control
class_name Item

export(Texture) var texture
var hideableControl:HideableControl
var label:Label
var tier:int = 0
var flavourText:String = "No flavour given"

func _init() -> void:
	addHideableLabel()

func addHideableLabel() -> void:
	hideableControl = preload("res://Prefabs/HideableControl.tscn").instance()
	add_child(hideableControl)
	label = preload("res://Prefabs/FontLabel.tscn").instance()
	hideableControl.showTime = 1.0
	hideableControl.hideTime = 0.5
	hideableControl.instantHide()
	hideableControl.add_child(label)
	label.text = flavourText
	label.modulate = Color(1.0, 1.0, 1.0, 1.0)
	var font = label.get_font("font")
	font.size = 20
	label.add_font_override("font", font)
	GlobalNodes.getGUI().get_child(0).add_child(self)

# Extending classes should do something up damage/ health/ whatever
func do() -> void:
	display()

func display() -> void:
	hideableControl.show()
	label.text = flavourText
	yield(get_tree().create_timer(hideableControl.showTime), "timeout")
	hideableControl.hide()

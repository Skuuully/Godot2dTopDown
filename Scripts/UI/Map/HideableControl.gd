extends Control
class_name HideableControl

onready var tween:Tween = $ShowHide
 
var showing:bool = true
var showTime:float = 0.5
var hideTime:float = 0.2

func show():
	if !showing:
		tween.interpolate_property(self, "modulate:a",
		 0, 1, showTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
		showing = true
		enableInput(true)

func hide():
	if showing:
		tween.interpolate_property(self, "modulate:a",
		 1, 0, hideTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
		showing = false
		enableInput(false)

func enableInput(enable:bool)-> void:
	set_process_input(enable)
	set_process_unhandled_input(enable)
	set_process_unhandled_key_input(enable)
	enableMouse(enable, null)
	for child in Utils.getAllChildren(self):
		child.set_process_input(enable)
		child.set_process_unhandled_input(enable)
		set_process_unhandled_key_input(enable)
		enableMouse(enable, child)

# @param control Optional, will use this node if no specific node given
func enableMouse(enable:bool, control:Control) -> void:
	var node:Control = self
	if control != null:
		node = control

	if enable:
		node.mouse_filter = MOUSE_FILTER_PASS
	else:
		node.mouse_filter = MOUSE_FILTER_IGNORE

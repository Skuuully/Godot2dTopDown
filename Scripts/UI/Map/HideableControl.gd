extends Control

onready var tween = $ShowHide
 
var showing:bool = true

func show():
	if !showing:
		tween.interpolate_property(self, "modulate:a",
		 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
		showing = true
		enableInput(true)

func hide():
	if showing:
		tween.interpolate_property(self, "modulate:a",
		 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
		showing = false
		enableInput(false)

func enableInput(enable:bool)-> void:
	set_process_input(enable)
	set_process_unhandled_input(enable)
	for child in Utils.getAllChildren(self):
		child.set_process_input(enable)
		child.set_process_unhandled_input(enable)

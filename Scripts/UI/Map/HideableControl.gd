extends Control

onready var tween = $ShowHide
 
var showing:bool = true

func show():
	if !showing:
		tween.interpolate_property(self, "modulate:a",
		 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
		showing = true

func hide():
	if showing:
		tween.interpolate_property(self, "modulate:a",
		 1, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
		showing = false

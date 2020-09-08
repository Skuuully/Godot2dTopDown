# DamageText

extends RichTextLabel

onready var timer = $Timer
onready var tween = $Tween
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	tween.interpolate_property(self, "modulate:a",
	 1, 0, timer.wait_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
	var startPos = rect_position.y
	var endPos = rect_position.y - rng.randi_range(10, 55)
	tween.interpolate_property(self, "rect_position:y",
	 startPos, endPos, timer.wait_time /2.0, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	
	var xStartPos = rect_position.x
	var leftRight = (rng.randi() % 2) + 1
	var xEndPos
	if leftRight > 1:
		xEndPos = rect_position.x + rng.randi_range(-5, -20)
	else:
		xEndPos = rect_position.x + rng.randi_range(5, 20)
	tween.interpolate_property(self, "rect_position:x",
	 xStartPos, xEndPos, timer.wait_time /2.0, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	
	Utils.checkError(tween.connect("tween_all_completed", self, "_onFadeCompleted"))

func _onFadeCompleted() -> void:
	queue_free()

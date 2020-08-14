# DamageText

extends RichTextLabel

onready var timer = $Timer
export var _alphaReduction = 2
var yRise = -1

func _ready():
	text = ""

func _physics_process(delta):
	modulate.a -= (_alphaReduction * delta)
	rect_position.y += yRise
	if timer.time_left <= 0:
		queue_free()

extends CPUParticles2D

export var ALPHA_REDUCTION = 2
	
func _physics_process(delta):
	modulate.a -= ALPHA_REDUCTION * delta
	if modulate.a <= 0:
		queue_free()

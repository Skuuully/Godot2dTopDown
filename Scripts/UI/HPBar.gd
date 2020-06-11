extends TextureProgress

func connectToPlayer(player):
	player.connect("damageTaken", player, "_onDamageTaken")
	pass

# Handler for when the player takes damage
func _onDamageTaken(damage):
	tint_progress -= damage
	pass

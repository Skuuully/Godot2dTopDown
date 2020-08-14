# Player Camera
# Follows the player when the player is not in a room

extends Camera2D

# Activates the camera and set it initial position
func activateCamera(newPosition):
	current = true;
	position = newPosition

func playerMoved(playerPosition):
	position = playerPosition
	pass

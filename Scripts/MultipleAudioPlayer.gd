# MultipleAudioPlayer
# Call play function to use, handles multiple calls to play at a time which will
# fire up new audio players as required to play the audio without interrupting
# the current effect
extends Node2D
class_name MultipleAudioPlayer

var audioPlayers = []
var map = {}

func play(audioClip, pitch:float = 1.0, db = 0.0) -> void:
	var audioPlayer = getAudioPlayer()
	audioPlayer.stream = audioClip
	audioPlayer.pitch_scale = pitch
	audioPlayer.volume_db = db
	audioPlayer.play()
	map[audioPlayer] = true

func getAudioPlayer() -> AudioStreamPlayer2D:
	var audioPlayer = null
	var i = -1
	for used in map.values():
		i += 1
		if !used:
			audioPlayer = map.keys()[i]
	
	if audioPlayer == null:
		audioPlayer = createAudioPlayer()
	
	return audioPlayer

func createAudioPlayer() -> AudioStreamPlayer2D:
	var audioPlayer = AudioStreamPlayer2D.new()
	audioPlayers.push_back(audioPlayer)
	add_child(audioPlayer)
	map[audioPlayer] = false
	audioPlayer.connect("finished", self, "onClipFinished", [audioPlayer])
	return audioPlayer

func onClipFinished(audioPlayer) -> void:
	map[audioPlayer] = false

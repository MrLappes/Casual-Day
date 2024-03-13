extends AudioStreamPlayer2D
class_name InsultManager
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Handles you getting shouted at or being complimented by enemies.
"""


@export var good_audio : Array[AudioStream] = []
@export var suck_audio : Array[AudioStream] = []

func play_good() -> void:
	if good_audio.size() > 0:
		stream = good_audio[randi_range(0,good_audio.size()-1)]
		play()

func play_bad() -> void:
	if suck_audio.size() > 0:
		stream = suck_audio[randi_range(0,suck_audio.size()-1)]
		play()

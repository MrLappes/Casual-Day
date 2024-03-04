extends Node
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

This script plays the mooosik, even between scenes. 
It is autoloaded and can be called as "Audio"
"""
@onready var music_stream_player = $MusicStreamPlayer as AudioStreamPlayer

var song_list : Dictionary = {
	"Main Song" : load("res://moosik/Corrupt.mp3")
}


func play_moosic(song_title : String) -> void:
	music_stream_player.stream = song_list[song_title]
	music_stream_player.play()

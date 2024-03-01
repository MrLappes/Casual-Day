extends Node

@onready var music_stream_player = $MusicStreamPlayer as AudioStreamPlayer

var song_list : Dictionary = {
	"Main Song" : load("res://moosik/Corrupt.mp3")
}


func play_moosic(song_title : String) -> void:
	music_stream_player.stream = song_list[song_title]
	music_stream_player.play()

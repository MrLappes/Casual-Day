extends Node
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

This script plays the mooosik, even between scenes. 
It is autoloaded and can be called as "Audio"
Corrupt.mp3 was created by me.
The other songs were created by: https://de.fiverr.com/erekl3
"""
signal battle_music_finished
@onready var music_stream_player = $MusicStreamPlayer as AudioStreamPlayer
@onready var animation_player = $AnimationPlayer as AnimationPlayer

var current_song : String = ""
var transitioning : bool = false

var song_list : Dictionary = {
	"Main Menu Song" : load("res://moosik/main_menu.mp3"),
	"Main Theme" :  load("res://moosik/main_theme.mp3"),
	"Battle Music" : load("res://moosik/battle_music_full.mp3"),
	"Battle Music Looping" : load("res://moosik/battle_music_looping.mp3"),
	"Player Sucks" : load("res://moosik/bad_player.mp3"),
	"Corrupt" : load("res://moosik/Corrupt.mp3")
}

func play_moosic(song_title : String) -> void:
	song_title = get_correct_theme(song_title)
	if current_song == song_title:
		return
	music_stream_player.volume_db = 0
	current_song = song_title
	music_stream_player.stream = song_list[song_title]
	music_stream_player.play()
	
func transition_play_moosic(song_title : String) -> void:
	song_title = get_correct_theme(song_title)
	if current_song == song_title:
		return
	animation_player.stop()
	current_song = song_title
	transitioning = true
	animation_player.play("switch_songs")

func get_correct_theme(song_title : String) -> String:
	if Globals.sad and song_title == "Main Theme":
		return "Main Menu Song"
	return song_title

func transition_state() -> void:
	transitioning = false
	music_stream_player.stream = song_list[current_song]
	music_stream_player.play()

func switch_to_main_theme_no_anim() -> void:
	current_song = get_correct_theme("Main Theme")
	Globals.in_battle = false
	print(current_song)
	music_stream_player.stream = song_list[current_song]
	music_stream_player.play()
	battle_music_finished.emit()
	
func stop_battle_fade() -> void:
	animation_player.stop()
	
func start_battle_fade() -> void:
	animation_player.play("battle_fade")
	
func stop_anim_player() -> void:
	animation_player.stop()

func _on_music_stream_player_finished():
	if current_song == "Battle Music" and not transitioning:
		play_moosic("Battle Music Looping")

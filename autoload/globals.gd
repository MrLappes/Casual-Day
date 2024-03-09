extends Node

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

This script holds the global variables and is autoloaded as "Globals"
Reset function is used for when you restart the game as this is autoloaded
We dont want the player to keep his progress.
"""
signal level_changed
# Character States
var tutorial : bool = true
var dead : bool = false
var main_character_posing : bool = false
var main_character_current_pose : String = "Idle" # Other states: "oiling", "Side" "Mosto" "Abdominal" "Back"
var main_character_stripping : bool = false
# Allows to stop main Character from posing, might be usefull later
var block_main_character_posing : bool = false
var in_battle : bool = false
var sad : bool = true

# Stats of main Character
var level : int = 0
var xp : int = 0
var level_up_xp = 10
var max_level : int = 69
var player_walk_speed : float = 300.0
var player_aerial_walk_speed : float = 180.0
var player_jump_velocity : float = 400.0
var max_self_awareness_level : float = 100.0
var max_global_progress_level : float = 100.0
var self_awareness_modifier : float = -3.0 # Will be removed each process multiplied by delta
var self_awareness_clothes_on_modifier : float = -1.0 # Will be removed each process multiplied by delta if he has clothes on
var posing_self_awareness_modifier : float = 4.0
var self_awareness_timer : float = 3.0
var self_awareness_pause_timer : float = 3.0
var perfect_pose_time : float = 7.0
var perfect_pose_time_window : float = 1.0

func reset_globals() -> void:
	tutorial = true
	
	# Character States
	dead = false
	main_character_posing = false
	main_character_current_pose = "Idle"
	main_character_stripping = false
	block_main_character_posing = false
	in_battle = false
	sad = true

	# Stats of main Character
	level = 0
	xp = 0
	level_up_xp = 10
	max_level = 69
	player_walk_speed = 300.0
	player_aerial_walk_speed = 180.0
	player_jump_velocity = 400.0
	max_self_awareness_level = 100
	max_global_progress_level = 100
	self_awareness_modifier = -2.0 # Will be removed each process multiplied by delta
	self_awareness_clothes_on_modifier = -1.0 # Will be removed each process multiplied by delta if he has clothes on
	posing_self_awareness_modifier = 2.0
	self_awareness_timer = 3
	self_awareness_pause_timer = 3
	perfect_pose_time = 7.0
	perfect_pose_time_window = 1.0
	
func get_self_awareness_modifier(is_clothed : bool, nearby_enemy_modifier : float) -> float:
	if main_character_posing:
		return posing_self_awareness_modifier + nearby_enemy_modifier
	return self_awareness_clothes_on_modifier if is_clothed else self_awareness_modifier + nearby_enemy_modifier
		
func add_exp(value : int) -> void:
	xp += value
	if xp > level_up_xp and level < max_level:
		xp = xp - level_up_xp
		level += 1
		level_changed.emit(level)
		
	

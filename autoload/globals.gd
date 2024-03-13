extends Node

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

This script holds the global variables and is autoloaded as "Globals"
Reset function is used for when you restart the game as this is autoloaded
We dont want the player to keep his progress.
"""
signal level_changed
signal xp_changed

var pause : bool = false
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
var oiled_up_modifier : float = 0.0
var oiled_up : bool = false
var is_clothed : bool = false # Only used for smooth transition to end cutscene

# Stats of main Character
var level : int = 0
var xp : int = 0
var level_up_xp = 10
var max_level : int = 20
var player_walk_speed : float = 200.0
#var player_aerial_walk_speed : float = 180.0
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
	pause = false
	# Character States
	dead = false
	main_character_posing = false
	main_character_current_pose = "Idle"
	main_character_stripping = false
	block_main_character_posing = false
	in_battle = false
	sad = true
	oiled_up_modifier = 0.0
	oiled_up = false

	# Stats of main Character
	level = 0
	xp = 0
	level_up_xp = 10
	max_level = 20
	player_walk_speed = 200.0
#	player_aerial_walk_speed = 180.0
	player_jump_velocity = 400.0
	max_self_awareness_level = 100
	max_global_progress_level = calculate_xp(max_level)
	self_awareness_modifier = -1.7 # Will be removed each process multiplied by delta
	self_awareness_clothes_on_modifier = -1.0 # Will be removed each process multiplied by delta if he has clothes on
	posing_self_awareness_modifier = 2.0
	self_awareness_timer = 3
	self_awareness_pause_timer = 3
	perfect_pose_time = 7.0
	perfect_pose_time_window = 1.0
	
func get_self_awareness_modifier(is_clothed : bool, nearby_enemy_modifier : float) -> float:
	var level_modifier = (float(level) / float(max_level))
	var oil_modifier = 0.0 if not oiled_up else oiled_up_modifier
	var self_awareness
	if main_character_posing:
		self_awareness = posing_self_awareness_modifier + nearby_enemy_modifier + (level_modifier * 2)
		if not sad:
			self_awareness += 0.8
	else:
		self_awareness = self_awareness_clothes_on_modifier + level_modifier if is_clothed else self_awareness_modifier + nearby_enemy_modifier + level_modifier
		if not sad:
			self_awareness += 1.7
	return self_awareness + oil_modifier
		
		
func add_xp(value : int) -> void:
	xp += value
	while xp >= level_up_xp and level < max_level:
		# formula from https://blog.jakelee.co.uk/converting-levels-into-xp-vice-versa/
		level += 1
		level_up_xp = calculate_xp(level)
		level_changed.emit(level)
	xp_changed.emit(xp)

func calculate_xp(level_needed : int) -> int:
	if level_needed > max_level:
		level_needed = max_level
	return int(pow((level_needed / 0.3), 2)) + 10

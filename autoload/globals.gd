extends Node

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

This script holds the global variables and is autoloaded as "Globals"
"""

# Character States
var dead : bool = false
var main_character_posing : bool = false
var main_character_oiling : bool = false
var main_character_current_pose : String = "Idle" # Other states: "oiling", "Side" "Mosto" "Abdominal" "Back"
var main_character_stripping : bool = false
# Allows to stop main Character from posing, might be usefull later
var block_main_character_posing : bool = false

# Stats of main Character
var player_walk_speed : float = 300.0
var player_aerial_walk_speed : float = 180.0
var player_jump_velocity : float = 400.0
var max_oil_level : float = 100.0
var max_aesthetics_level : float = 100.0
var oil_level_modifier : float = 1 # Will be removed each process multiplied by delta
var oil_level_clothes_on_modifier : float = 3.0 # Will be removed each process multiplied by delta if he has clothes on
var oil_yourself_modifier : float = 10.0
var oil_timer : float = 3.0
var oil_pause_timer : float = 3.0

func reset_globals() -> void:
	# Character States
	Globals.dead = false
	Globals.main_character_posing = false
	Globals.main_character_oiling = false
	Globals.main_character_current_pose = "Idle" # Other states: "oiling", "Side" "Mosto" "Abdominal" "Back"
	Globals.main_character_stripping = false
	# Allows to stop main Character from posing, might be usefull later
	Globals.block_main_character_posing = false

	# Stats of main Character
	Globals.max_oil_level = 100
	Globals.max_aesthetics_level = 100
	Globals.oil_level_modifier = 1 # Will be removed each process multiplied by delta
	Globals.oil_level_clothes_on_modifier = 3.0 # Will be removed each process multiplied by delta if he has clothes on
	Globals.oil_yourself_modifier = 10
	Globals.oil_timer = 3
	Globals.oil_pause_timer = 3

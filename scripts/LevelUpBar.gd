extends CustomProgressBar
class_name CustomLevelUpBar

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Custom class to hold the weird level up bar.
Just indicates how much xp is needed for the next level up.
"""

@export var background_color : Color = Color(0,1,0)

func _ready():
	label.text = "%d / %d" % [0, Globals.level_up_xp]
	progress_bar.min_value = 0.0
	progress_bar.max_value = Globals.level_up_xp
	change_bar_color(background_color)

func set_xp_value(value : int) -> void:
	progress_bar.value = value

func change_range() -> void:
	if not Globals.level == 0:
		var xp = Globals.xp
		var level_up_xp = Globals.level_up_xp
		var min_xp = progress_bar.max_value
		progress_bar.min_value = min_xp
		progress_bar.max_value = level_up_xp
		progress_bar.value = xp
		label.text = "%d / %d" % [(xp-min_xp),(level_up_xp-min_xp)]

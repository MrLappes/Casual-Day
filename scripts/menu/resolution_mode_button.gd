extends Control
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

This script controlls the adding of the different Resolutions.
Taken from this tutorial:
	https://www.youtube.com/watch?v=fFIST_4wmyI&ab_channel=CoffeeCrow
"""
@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICT : Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080": Vector2i(1920, 1080),
	"2560 x 1440": Vector2i(2560, 1440),
	"3840 x 2160": Vector2i(3840, 2160)
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


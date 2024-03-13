class_name CustomValueLabel
extends Control
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Helper class to have a label behave a bit kinda like a slider.
"""
@onready var label = $Count/Label as Label
@onready var progress_text = $Count/ProgressText as Label
var max_value : int = 100
const MIN_VALUE : int = 0
var value : int = 0
@export var label_text : String = "Level"

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = label_text
	
	
func set_value(new_value : int) -> void:
	if MIN_VALUE <= new_value and new_value <= max_value:
		value = new_value
		progress_text.text = str(value)
	else:
		push_error("Not a valid value: %d, min: %d, max: %d" % [value, MIN_VALUE, max_value])
	
func get_value() -> int:
	return value
	
func set_max_level(new_value : int) -> void:
	max_value = new_value
	

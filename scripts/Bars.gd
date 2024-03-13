class_name CustomProgressBar
extends Control
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Simple helper class for gui progress bars
"""
@onready var label = $Count/Label as Label
@onready var progress_bar = $Count/ProgressBar as ProgressBar

@export var label_text : String = "Aesthetics"

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = label_text
	
	
func set_progress(value : float) -> void:
	progress_bar.value = clampf(value, progress_bar.min_value, progress_bar.max_value)
	
func get_progress() -> float:
	return progress_bar.value
	
func set_max_level(value : float) -> void:
	progress_bar.max_value = value
	
func change_bar_color(fill_color : Color) -> void:
	progress_bar.remove_theme_stylebox_override("fill")
	var bar_fill = StyleBoxFlat.new()
	bar_fill.bg_color = fill_color
	progress_bar.add_theme_stylebox_override("fill", bar_fill)

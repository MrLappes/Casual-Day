class_name CustomEnemyProgressBar
extends Control
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Simple helper class for Enemy progress bars
"""
@onready var progress_bar = $ProgressBar as ProgressBar
@export var max_color : Color = Color(1,0,0)
@export var min_color : Color = Color(0,0,0)
	
func _ready():
	set_progress(progress_bar.max_value)
	
func set_progress(value : float) -> void:
	value = clampf(value, progress_bar.min_value, progress_bar.max_value)
	progress_bar.value = value
	var progress_ratio = value / progress_bar.max_value
	var interpolated_color = min_color.lerp(max_color, progress_ratio)
	change_bar_color(interpolated_color)
	
func get_progress() -> float:
	return progress_bar.value
	
func set_max_progress(value : float) -> void:
	progress_bar.max_value = value
	
func change_bar_color(fill_color : Color) -> void:
	progress_bar.remove_theme_stylebox_override("fill")
	var bar_fill = StyleBoxFlat.new()
	bar_fill.bg_color = fill_color
	progress_bar.add_theme_stylebox_override("fill", bar_fill)

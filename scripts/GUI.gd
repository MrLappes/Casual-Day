class_name Gui
extends Container

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Helper Class to hold all the GUI elements of the player
"""

@onready var self_awareness_bar = $HBoxContainer/Bars/SelfAwareness as CustomProgressBar
@onready var global_progress_bar = $HBoxContainer/Bars/GlobalProgress as CustomProgressBar
@onready var level_up_bar = $HBoxContainer/Bars/Level/LevelUpBar as CustomLevelUpBar
@onready var level = $HBoxContainer/Bars/Level as CustomValueLabel

@export var global_progress_start_color : Color = Color(0.0, 0.0, 0.0)
@export var global_progress_end_color : Color = Color(0.0, 1.0, 0.0) # Green when full

@export var self_awareness_start_color : Color = Color(1.0, 0.0, 0.0) # Red at zero
@export var self_awareness_end_color : Color = Color(0.0, 1.0, 0.0) # Green when full
var actual_self_awareness_value : float = 100.0
var actual_global_progress_value : float = 0.0
var first_time_sad : bool = true
signal complete_global_score
signal self_awareness_critical
signal self_awareness_zero
@export var death_messages : Array[String] = ["You Died."]

func _ready():
	set_self_awareness_level(Globals.max_self_awareness_level)
	set_self_awareness_max_level(Globals.max_self_awareness_level)
	set_global_progress_level(0.0)
	set_global_progress_max_level(Globals.max_global_progress_level)
	set_level_max_value(Globals.max_level)
	_set_level(Globals.level)
	Globals.level_changed.connect(_set_level)
	Globals.xp_changed.connect(set_global_progress_level)

func set_self_awareness_level(value : float) -> void:
	value = clampf(value, 0, Globals.max_self_awareness_level)
	if value <= 0:
		self_awareness_zero.emit(death_messages[randi_range(0, death_messages.size() - 1)])
	elif value <= 30.0 and first_time_sad:
		self_awareness_critical.emit()
		first_time_sad = false
	elif not first_time_sad and value > 30.0:
		first_time_sad = true
	actual_self_awareness_value = value
	self_awareness_bar.set_progress(value)
	update_self_awareness_bar_color(value)

func update_self_awareness_bar_color(value : float) -> void:
	var progress_ratio = value / Globals.max_self_awareness_level
	var interpolated_color = self_awareness_start_color.lerp(self_awareness_end_color, progress_ratio)
	self_awareness_bar.change_bar_color(interpolated_color)

func get_self_awareness_level() -> float:
	return actual_self_awareness_value
	
func add_self_awareness_level(value : float) -> float:
	set_self_awareness_level(actual_self_awareness_value + value)
	return actual_self_awareness_value

func set_global_progress_level(value : int) -> void:
	value = clampf(value, 0, Globals.max_global_progress_level)
	if value == Globals.max_global_progress_level:
		complete_global_score.emit()
	global_progress_bar.set_progress(value)
	update_global_progress_bar_color(value)
	level_up_bar.set_xp_value(value)

func update_global_progress_bar_color(value : float) -> void:
	var progress_ratio = value / Globals.max_global_progress_level
	var interpolated_color = global_progress_start_color.lerp(global_progress_end_color, progress_ratio)
	global_progress_bar.change_bar_color(interpolated_color)

func get_global_progress_level() -> float:
	return global_progress_bar.get_value()

func set_self_awareness_max_level(value : float) -> void:
	self_awareness_bar.set_max_level(value)
	Globals.max_self_awareness_level = value

func set_global_progress_max_level(value : int) -> void:
	global_progress_bar.set_max_level(value)
	Globals.max_global_progress_level = value
	
func _set_level(value : int) -> void:
	value = clampi(value,level.MIN_VALUE,level.max_value)
	level.set_value(value)
	level_up_bar.change_range()
	set_self_awareness_max_level(Globals.max_self_awareness_level + 5)

	
func set_level_max_value(value : int) -> void:
	level.set_max_level(value)
	Globals.max_level = value


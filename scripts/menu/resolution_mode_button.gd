extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICT : Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080": Vector2i(1920, 1080)
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


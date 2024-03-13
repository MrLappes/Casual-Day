extends Sprite2D
class_name OilLabel

@onready var oil_count_label = $OilCountLabel as Label

func _ready():
	visible = false
	
func change_oil_count(count : int) -> void:
	oil_count_label.text = str(count)


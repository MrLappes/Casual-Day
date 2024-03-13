extends Node2D

# Deprecated as this shader was bullying me and not working as expected
var blooming : bool = false
@onready var animation_player = $AnimationPlayer as AnimationPlayer

func _ready():
	animation_player.play("bloom")

func change_speed_bloom() -> void:
	animation_player.speed_scale = randf_range(0.5, 2.0)

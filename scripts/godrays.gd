extends ColorRect
class_name GodRays
var player : MainCharacterWithStates = null

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

This script shows the player he is doing something right by spawning godrays
"""

@onready var area_2d = $Area2D as Area2D
@onready var godray_player = $GodrayPlayer as AnimationPlayer


func setup(character : MainCharacterWithStates):
	godray_player.play("godrays")
	Audio.battle_music_finished.connect(hide_godrays)
	material = material.duplicate()
	player = character
	_setup_player()
			
func _setup_player():
	player.bad_pose.connect(hide_godrays)
	player.enemy_defeated.connect(hide_godrays)

func hide_godrays() -> void:
	if player:
		player.active_godray = false
	godray_player.play("godrays_reverse")

func remove_node():
	queue_free()


func _on_area_2d_body_exited(body):
	if body is MainCharacterWithStates:
		hide_godrays()

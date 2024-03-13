extends AnimationPlayer
class_name VignettePlayer

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Vignette shader management to indicate that the player is dying.
This was replaced by vignette management within PlayerWithStates.gd
"""

var allow_vignette_movement : bool = false

func play_vignette_movement() -> bool:
	if allow_vignette_movement:
		play("vignette_movement")
		return true
	return false
	
func show_vignette() -> void:
	play("show_vignette")
	allow_vignette_movement = false



func _on_animation_finished(anim_name):
	if anim_name == "show_vignette":
		allow_vignette_movement = true
		play_vignette_movement()

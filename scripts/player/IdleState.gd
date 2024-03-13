extends State

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

In this state the character does nothing.
(Except losing self esteem)
"""

func enter(_params = null):
	update_animation()
		
func update_animation() -> void:
	# The only logic needed to be idleing.
	if player.is_clothed:
		player.set_animation("Idle_clothes")
	else:
		player.set_animation("Idle")
	

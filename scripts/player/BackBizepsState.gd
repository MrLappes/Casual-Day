extends BasePoseState

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

In this state you can hit my favourite pose animation
"""

func enter(_params = null):
	update_animation()
	
func update_animation():
	player.set_animation("Back")

func successfull_pose():
	# Called when time window was correctly hit.
	pass

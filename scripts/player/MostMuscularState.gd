extends BasePoseState

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Here you can hit the most muscular pose
"""

func enter(_params = null):
	update_animation()
	
func update_animation():
	player.set_animation("Mosto")
	
func successfull_pose():
	pass

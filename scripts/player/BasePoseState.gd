extends State
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

The small substates where the player poses are inheriting this.
Notice the get_parent().get_parent() instead of just get_parent()
And the new successfull pose functions
"""
class_name BasePoseState

func _enter_tree():
	# When the state node is added to the scene tree, automatically get the player reference
	player = get_parent().get_parent()
	
func successfull_pose():
	# Called when time window was correctly hit.
	pass
	
func messed_up():
	# Called when time window was not hit.
	pass
	
func effect():
	# pose specific effect on end of pose timer
	pass

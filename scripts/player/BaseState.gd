extends Node2D
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

You see the cool player states?
They all inherit from this class.
Cool right?
"""
class_name State

var player: MainCharacterWithStates

func _enter_tree():
	# When the state node is added to the scene tree, automatically get the player reference
	player = get_parent()

func enter(params = null):
	# Called when entering the state, 'params' can be used to pass data into the state
	pass

func exit():
	# Called when exiting the state
	pass

func process(delta):
	# Called every frame when this state is active
	pass

func physics_process(delta):
	# Called every physics frame when this state is active
	pass
	
func ignores_input() -> bool:
	# Can be used to see if switching to walking is allowed
	# Was important for the jump function, now its just in here so 
	# that i dont have to worry about bugs if i remove it.
	return false 

func handle_input(event):
	# Handle input events specific to this state
	pass

func update(params = null):
	# Update function to handle non-physics related updates
	pass

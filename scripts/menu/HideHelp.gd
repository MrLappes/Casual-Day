extends Node2D


func _unhandled_key_input(event):
	if not Globals.pause and event.is_action_pressed("controls"):
		visible = !visible

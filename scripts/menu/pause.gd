extends Control

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0
Shows Menu, game isnt actually paused though, for now. (except the player)
"""

@onready var options_menu = $Options as Control
@onready var pause_menu = $".." as Container


func _on_start_button_pressed():
	pause_menu.visible = false
	Globals.pause = false

func _on_option_button_pressed():
	_set_options_visible(!options_menu.visible)
	
func _set_options_visible(visibility : bool):
	options_menu.visible = visibility

func _on_quit_button_pressed():
	get_tree().quit()

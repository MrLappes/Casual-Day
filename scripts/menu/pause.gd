extends Control

@onready var options_menu = $Options as OptionsMenu
@onready var pause_menu = $".." as Container


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	pause_menu.visible = false


func _on_option_button_pressed():
	_set_options_visible(!options_menu.visible)
	
func _set_options_visible(visibility : bool):
	options_menu.visible = visibility


func _on_quit_button_pressed():
	get_tree().quit()

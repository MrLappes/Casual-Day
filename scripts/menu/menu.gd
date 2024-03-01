extends Control

@onready var options_menu = $MenuButtons/Options as OptionsMenu
@onready var menu_buttons = $MenuButtons as Control
@onready var endposition = $MenuButtons/Endposition as Control
@onready var player = $Player as AnimatedSprite2D

var t : float = 0.0
@onready var start_position : Vector2 = player.position

# Called when the node enters the scene tree for the first time.
func _ready():
	Audio.play_moosic("Main Song")
	toggleMenuVisibility(false)





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.distance_to(endposition.position) > 10:
		t += delta * 0.4
		print(player.position)
		player.position = start_position.lerp(endposition.position, t)
	else:
		player.play("default")
		toggleMenuVisibility(true)


func toggleMenuVisibility(visible : bool) -> void:
	menu_buttons.visible = visible


func _on_start_button_pressed():
		get_tree().change_scene_to_file("res://main_game.tscn")


func _on_option_button_pressed():
	options_menu.visible = !options_menu.visible


func _on_credits_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()


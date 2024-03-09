extends Control
"""
Main Menu Functionality.
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0
Features:
	1. Walk in animation
	2. Girl scrolling at random intervals
	3. Option Menu popup
	4. Robber robbing girl
	5. Robber eye movement
	6. Player Death
	7. Redirect to game
	8. Exit game
"""

# All important objects
@onready var options_menu = $MenuButtons/Options as Control
@onready var menu_buttons = $MenuButtons as Control
@onready var endposition = $MenuButtons/Endposition as Control
@onready var player = $Player as AnimatedSprite2D
@onready var robber = $Robber as AnimatedSprite2D
@onready var girl = $girl as AnimatedSprite2D
@onready var death_label = $death_label as Label
@export var first_scene : PackedScene

# Knowledge i need for coding
var t : float = 0.0
var intro_finished : bool = false
@onready var scroll_phone_timer = $scroll_phone_timer as Timer
@onready var move_eyes_timer = $move_eyes_timer as Timer
@onready var start_position : Vector2 = player.position


func _ready():
	# Play global audio
	Audio.play_moosic("Main Menu Song")
	# Menu is invisible whilst walking in
	toggleMenuVisibility(false)
	# Useful for game restarts
	Globals.reset_globals()
	
func _process(delta):
	# Walk in
	if player.position.distance_to(endposition.position) > 10:
		t += delta * 0.4
		player.position = start_position.lerp(endposition.position, t)
	elif not intro_finished:
		# Show Menu
		player.play("default")
		toggleMenuVisibility(true)
		move_eyes_timer.start(4)
		intro_finished = true


# Menu visibility helper function
func toggleMenuVisibility(turn_visible : bool) -> void:
	menu_buttons.visible = turn_visible

# Get rid of clothes and start game
func _on_start_button_pressed():
	# works but probably would have been nicer 
	# with animationplayer on finished logic
	toggleMenuVisibility(false)
	await wait(0.5)
	player.play("strip")
	await wait(1.0)
	player.play("idle")
	await wait(1.0)
	get_tree().change_scene_to_packed(first_scene)

# Wait helper function
func wait(duration):  
	await get_tree().create_timer(duration, false, false, true).timeout

# Show options
func _on_option_button_pressed():
	options_menu.visible = !options_menu.visible

# Die.
func _on_credits_button_pressed():
	move_eyes_timer.stop()
	toggleMenuVisibility(false)
	$AnimationPlayer.play("hide_girl")
	robber.play("shoot")
	await wait(2.0)
	death_label.visible = true
	player.play("death")
	await wait(5.0)
	girl.material.set("shader_parameter/darkening_factor", 0)
	get_tree().change_scene_to_file("res://Scenes/StartScreen.tscn")

# Close Game
func _on_quit_button_pressed():
	get_tree().quit()
	

func _on_scroll_phone_timer_timeout():
	# Girl randomly scrolls her phone
	girl.play("scroll")
	scroll_phone_timer.wait_time = randf_range(1.2, 10.0)


func _on_move_eyes_timer_timeout():
	# Robber randomly looks at you
	robber.play("move_eyes")
	move_eyes_timer.wait_time = randf_range(2.0,14.0)

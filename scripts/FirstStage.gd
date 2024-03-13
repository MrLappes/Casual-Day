extends Node2D

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Tutorial and basic on load of first stage logic.
"""

@onready var girl = $girl as Girl
@onready var robber = $Robber as BasicEnemy
@onready var player = $PlayerWStatesTest as MainCharacterWithStates
@onready var tutorial_label = $TutorialLabel as Label

@export var tutorial_texts : Array[String] = []
var current_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player.keep_self_awareness_level_timer.stop()
	current_index = 0
	girl.hide_girl(true)
	tutorial_label.visible = true
	
func _input(event):
	if Globals.tutorial:
		if current_index == 4 and player.is_pose_event(event):
			get_next_tutorial_text()
			await get_tree().create_timer(7.0).timeout
			player.transition_to("IdleState")
			player.keep_self_awareness_level_timer.stop()
			player.self_awareness_loss_enabled = false
			Audio.stop_battle_fade()
			await get_tree().create_timer(3.0).timeout
			Audio.switch_to_main_theme_no_anim()
		elif current_index == tutorial_texts.size():
			get_next_tutorial_text()
		elif event.is_action_pressed("oil"):
			get_next_tutorial_text()
		else:
			get_viewport().set_input_as_handled()


func get_next_tutorial_text() -> void:
	if tutorial_texts.size() - 1 > current_index:
		tutorial_label.text = tutorial_texts[current_index]
		current_index += 1
	else:
		Globals.tutorial = false
		tutorial_label.queue_free()
		player.keep_self_awareness_level_timer.start(3.0)


func show_feelings():
	pass # Replace with function body.

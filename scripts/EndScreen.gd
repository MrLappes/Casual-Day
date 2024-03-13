extends Control
@onready var label = $girl/Label as Label
@onready var label_2 = $girl/Label2 as Label
@export var hot_girl_talk : Array[String] = []
var hot_girl_text : int = -1
var player : MainCharacterWithStates = null

# Called when the node enters the scene tree for the first time.
func _ready():
	label.visible = false
	label_2.visible = false
	if not Globals.sad:
		$girl.visible = true
	Globals.pause = false
	Globals.dead = false
	Globals.sad = false
	Globals.tutorial = false
	Globals.player_walk_speed *= 3
	Audio.transition_play_moosic("Main Theme")

func _unhandled_key_input(event):
	if label.visible and event.is_action_pressed("collect"):
		label.visible = false
		hot_girl_text = clampi(hot_girl_text + 1, 0, hot_girl_talk.size() - 1)
		label_2.text = hot_girl_talk[hot_girl_text]
		label_2.visible = true
		await get_tree().create_timer(5.0).timeout
		if player:
			label.visible = true
		label_2.visible = false
		
		

func _on_quit_button_pressed():
	get_tree().quit()


func _on_area_2d_2_body_entered(body):
	if body is MainCharacterWithStates:
		player = body
		label.visible = not label_2.visible


func _on_area_2d_2_body_exited(body):
	if body is MainCharacterWithStates:
		player = null
		label.visible = false

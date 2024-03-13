extends AnimatedSprite2D
class_name Girl

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

The Girl now has her own class.
She still only scrolls her phone.
There now is a shader able to make her hidden.
"""
@onready var player = $"../PlayerWStatesTest" as MainCharacterWithStates
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var scroll_phone_timer = $ScrollPhoneTimer as Timer
@onready var thank_you_label = $ThankYouLabel as Label
@onready var area_2d = $Area2D as Area2D
var in_love = false

# Called when the node enters the scene tree for the first time.
func _ready():
	thank_you_label.visible = false
	in_love = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_girl(darkened = false) -> bool:
	if material.get("shader_parameter/darkening_factor") != 0:
		if not darkened:
			animation_player.play("show_girl")
			return false
		return true
	else:
		if darkened:
			animation_player.play("hide_girl")
			return true
		return false

func _on_scroll_phone_timer_timeout():
	play("scroll")
	scroll_phone_timer.wait_time = randf_range(1.2, 10.0)
	
func _take_picture() -> void:
	if Globals.sad:
		Globals.sad = false
		Globals.add_xp(11)
	scroll_phone_timer.stop()
	play("take_picture")



func _on_animation_finished():
	if animation == "take_picture":
		play("scroll")
		scroll_phone_timer.start(randf_range(4.2, 12.0))


func _on_robber_death():
	scroll_phone_timer.stop()
	for body in area_2d.get_overlapping_bodies():
		if body is MainCharacterWithStates:
			player.perfect_pose.connect(_take_picture)
	hide_girl(false)
	thank_you_label.visible = true
	await get_tree().create_timer(3).timeout
	thank_you_label.text = "Do you want my number?"
	play("give_phone")
	await get_tree().create_timer(3).timeout
	thank_you_label.queue_free()
	play_backwards("give_phone")
	in_love = true
	for body in area_2d.get_overlapping_bodies():
		if body is MainCharacterWithStates:
			if not body.perfect_pose.is_connected(_take_picture):
				body.perfect_pose.connect(_take_picture)
	scroll_phone_timer.start(10.0)


func _on_area_2d_body_entered(body):
	if body is MainCharacterWithStates and in_love:
		if not body.perfect_pose.is_connected(_take_picture):
			body.perfect_pose.connect(_take_picture)
			



func _on_area_2d_body_exited(body):
	if body is MainCharacterWithStates and in_love:
		if body.perfect_pose.is_connected(_take_picture):
			body.perfect_pose.disconnect(_take_picture)

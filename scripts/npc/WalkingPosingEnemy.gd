extends PosingEnemy
class_name WalkingPosingEnemy

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Quick and dirty extension of myself as a walking enemy. To get some more life into the game
"""

var allow_walk : bool = false
@export var speed : float = 20.0
@export var sprite_flipped : bool = false
var start_spot : float = 0.0

func ready():
	random_pose_timer.start(randf_range(6.0, 12.0))
	get_and_check_animations()
	start_spot = global_position.x

func get_and_check_animations() -> void:
	var required_animations = ["Idle", "Walk"]
	var animation_names = sprite_frames.get_animation_names()
	for animation_string in required_animations:
		if not animation_string in animation_names:
			push_error("The required animation '%s' is missing from the Posing NPC %s." % [animation_string,name])
	for animation_string in animation_names:
		if animation_string.begins_with("pose"):
			posing_animations.append(animation_string)

func play_random_pose() -> void:
	var animation_string = posing_animations[randi_range(0,posing_animations.size() - 1)]
	play(animation_string)

	
func play_idle() -> void:
	play("Idle")

	
func play_walking(delta) -> void:
	if animation != "Walk":
		play("Walk")
		if global_position.x - start_spot < 100:
			speed = abs(speed)
		elif global_position.x - start_spot > -100:
			speed = -abs(speed)
		else:
			speed = speed if bool(randi_range(0, 1)) else -speed
	if sprite_flipped:
		flip_h = speed > 0
	else:
		flip_h = speed < 0
	global_position.x += speed * delta
	
func player_outside_progress(delta) -> void:
	if posing:
		add_self_esteem(10 * delta)
	elif allow_walk and not player:
		play_walking(delta)
	elif animation == "Idle":
		play_idle()
		
func player_within_progress(delta) -> void:
	if animation == "Walk":
		play_idle()

func _on_perfect_pose_timer_timeout():
	if player:
		player.gui.add_self_awareness_level(10 * current_strength_modifier)
	else:
		allow_walk = bool(randi_range(0, 1))
	posing = false
	play_idle()

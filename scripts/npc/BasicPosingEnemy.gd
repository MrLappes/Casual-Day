extends BasicEnemy
class_name PosingEnemy
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Some enemies can pose back at you to intimidate you.
This is their basic class.
"""

@onready var random_pose_timer = $RandomPoseTimer as Timer
@onready var perfect_pose_timer = $PerfectPoseTimer as Timer
@onready var sus_sounds_player = $SusSoundsPlayer as InsultManager
var posing_animations : Array[String] = [] 
var posing : bool = false
var pose_strength_decreased : bool = false
var pose_strength_modifier : float = 3.0

# Called when the node enters the scene tree for the first time.
func ready():
	random_pose_timer.start(randf_range(6.0, 12.0))
	get_and_check_animations()

func get_and_check_animations() -> void:
	var required_animations = ["Idle"]
	var animation_names = sprite_frames.get_animation_names()
	for animation_string in required_animations:
		if not animation_string in animation_names:
			push_error("The required animation '%s' is missing from the Posing NPC %s." % [animation_string,name])
	for animation_string in animation_names:
		if animation_string.begins_with("pose"):
			posing_animations.append(animation_string)

func player_within_progress(delta) -> void:
	if posing and not pose_strength_decreased:
		player_pose_strength += pose_strength_modifier
		pose_strength_decreased = true
	elif not posing and pose_strength_decreased:
		player_pose_strength -= pose_strength_modifier
		pose_strength_decreased = false
	elif posing:
		player.gui.add_self_awareness_level((-(current_strength_modifier + player_pose_strength + 5) + 1) * delta)
		
	
func player_outside_progress(delta) -> void:
	if posing:
		add_self_esteem(10 * delta)
		
		
func dead_progress(delta) -> void:
	if Globals.main_character_current_pose != "Idle":
		if not posing:
			play_random_pose()
		posing = true
	elif posing:
		play_idle()
		posing = false
		
func _on_player_entered(player_body : MainCharacterWithStates) -> void:
	random_pose_timer.stop()
	random_pose_timer.start(randf_range(1.0, 4.0))

func pause_pose_timer(pause_value : bool) -> void:
	random_pose_timer.paused = pause_value

func play_random_pose() -> void:
	var animation_string = posing_animations[randi_range(0,posing_animations.size() - 1)]
	play(animation_string)
	
func play_idle() -> void:
	play("Idle")

func _on_random_pose_timer_timeout():
	if player:
		random_pose_timer.wait_time = randf_range(9.0, 17.0)
	else:
		random_pose_timer.wait_time = randf_range(15.0, 60.0)
	if not posing:
		play_random_pose()
		posing = true
	perfect_pose_timer.start(randf_range(6.5, 7.5))

func _on_perfect_pose_timer_timeout():
	if player:
		player.gui.add_self_awareness_level(10 * current_strength_modifier)
	posing = false
	play_idle()

func _player_hit_perfect_pose() -> void:
	var hurts_much
	if posing:
		hurts_much = (current_strength_modifier + player_pose_strength - pose_strength_modifier) * 10
	else:
		hurts_much = (current_strength_modifier + player_pose_strength) * 10
	if hurts_much > 0:
		hurts_much *= -0.3
	sus_sounds_player.play_good()
	add_self_esteem(hurts_much)
	pass

func _player_messed_up() -> void:
	add_self_esteem(15)
	hint_label.player_messed_up(last_player_pose)
	sus_sounds_player.play_bad()

func _die() -> void:
	sus_sounds_player.play_good()
	hint_label.dead()
	Globals.add_xp(base_win_xp * (level + 1))
	dead = true
	if player:
		player.add_nearby_enemy_awareness_level(-current_strength_modifier)
		player.perfect_pose.disconnect(_player_hit_perfect_pose)
		player.bad_pose.disconnect(_player_messed_up)
		player.enemy_defeated.emit()
	area_2d.queue_free()
	self_esteem_bar.queue_free()
	die()
	death.emit()
	await get_tree().create_timer(5).timeout
	player = null


extends State

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

The heart of this game. Using this class you can switch 
between the different sub classes to hit epic poses.
"""

var current_state : BasePoseState
var pose_states : Dictionary = {}
var current_pose : InputEvent
var pressed_poses : Array[InputEvent] = []
var active_posing_time : float = 0
var perfect_pose : bool = false
var perfect_pose_time_low : float = 7.5
var perfect_pose_time_high : float = 6.5
var player_sucks : bool = true
var too_loooooong : bool = false
@onready var pose_time_label = $"../PoseTimeLabel" as Label
@onready var keep_self_awareness_level_timer = $"../KeepSelfAwarenessLevelTimer" as Timer

func _ready():
	for child in get_children():
		if child is BasePoseState:
			pose_states[child.name] = child

func enter(params = null):
	if params and "key_event" in params:
		if not player.endscreen:
			pose_time_label.visible = true
		current_pose = params["key_event"]
		if not current_pose in pressed_poses:
			pressed_poses.append(current_pose)
		if current_pose.is_action_pressed("abdominal"):
			transition_to("AbdominalState")
			Globals.main_character_current_pose = "Abdominal"
		elif current_pose.is_action_pressed("back"):
			transition_to("BackBizepsState")
			Globals.main_character_current_pose = "BackBizeps"
		elif current_pose.is_action_pressed("side"):
			transition_to("SideChestState")
			Globals.main_character_current_pose = "SideChest"
		elif current_pose.is_action_pressed("mosto"):
			transition_to("MostMuscularState")
			Globals.main_character_current_pose = "MostMuscular"
		active_posing_time = 0
		Globals.main_character_posing = true
		perfect_pose = false
		too_loooooong = false
		player.self_awareness_loss_enabled = true
		perfect_pose_time_low = Globals.perfect_pose_time - (Globals.perfect_pose_time_window / 2)
		perfect_pose_time_high = Globals.perfect_pose_time + (Globals.perfect_pose_time_window / 2)
		pose_time_label.set("theme_override_colors/font_color", Color(1,1,1))
		if player.enemies_nearby != 0:
			Audio.stop_anim_player()
		if not Globals.in_battle:
			player_sucks = false
			Globals.in_battle = true
			if player.enemies_nearby != 0:
				Audio.play_moosic("Battle Music")
	else:
		push_error("You need to send a valid key_event like this {'key_event': InputEvent} in order to pose")

		
func exit():
	if Globals.tutorial:
		pressed_poses.clear()
	current_state.exit()
	Globals.main_character_current_pose = "Idle"
	pose_time_label.visible = false
	Audio.start_battle_fade()
	Globals.main_character_posing = false

func process(delta):
	active_posing_time += 1 * delta
	if active_posing_time <= perfect_pose_time_low and active_posing_time >= perfect_pose_time_low - 1:
		pose_time_label.set("theme_override_colors/font_color", Color(1,0.3,0))
	elif active_posing_time >= perfect_pose_time_low and active_posing_time <= perfect_pose_time_high:
		perfect_pose = true
		pose_time_label.set("theme_override_colors/font_color", Color(16.0/255.0, 1.0, 30.0/255.0))
	elif active_posing_time > 10.0 and not too_loooooong:
		too_loooooong = true
		player.trying_to_cheat.emit()
		pose_time_label.set("theme_override_colors/font_color", Color(0.0, 0.0, 0.0))
		
	elif active_posing_time > perfect_pose_time_high and active_posing_time <= 10.0:
		perfect_pose = false
		pose_time_label.set("theme_override_colors/font_color", Color(1.0, 0.0, 0.0))
		if not player_sucks:
			player_sucks = true
			if player.enemies_nearby != 0:
				Audio.play_moosic("Player Sucks")
	pose_time_label.text = str(int(active_posing_time))

func update(params = null):
	"""
	Could be used to update current pose mode, if we dont do anything here though
	I think it feels better for me:
	if params and "key_event" in params:
		if params["key_event"] != current_pose:
			enter(params)
	"""
	if params and "key_event" in params:
		if not params["key_event"].is_match(current_pose):
			for pressed_pose in pressed_poses:
				if params["key_event"].is_match(pressed_pose):
					return
			pressed_poses.append(params["key_event"])
	pass
	
func register_current_pose(pose : InputEvent):
	# This function is used to determine if the player 
	# should switch to idle or to a different pose.
	for i in range(pressed_poses.size()):
		if pose.is_match(pressed_poses[i]):
			pressed_poses.remove_at(i)
			if i == 0 and not pressed_poses.is_empty():
				enter({"key_event": pressed_poses[0]})
			break
	return pressed_poses.is_empty()
	
func check_for_pose_event(pose : InputEvent):
	if pose.is_match(pressed_poses[0]):
		if perfect_pose:
			if player_sucks:
				if player.enemies_nearby != 0:
					Audio.play_moosic("Battle Music Looping")
				player_sucks = false
				keep_self_awareness_level_timer.start()
			player.gui.add_self_awareness_level(15)
			player.self_awareness_loss_enabled = false
			player.keep_self_awareness_level_timer.start(3.0)
			current_state.successfull_pose()
			player.perfect_pose.emit()
		elif too_loooooong:
			player_sucks_hard(-(7.0 + active_posing_time * 3))
		else:
			player_sucks_hard(-7.0)
			
func player_sucks_hard(self_awareness : float) -> void:
	if not player_sucks:
		player_sucks = true
		if player.enemies_nearby != 0:
			Audio.play_moosic("Player Sucks")
	player.gui.add_self_awareness_level(self_awareness)
	current_state.messed_up()
	player.bad_pose.emit()
	
func transition_to(state_name: String, params = null):
	if current_state:
		current_state.exit()
	else:
		push_warning("There is no active state, transitioning to %s" % state_name)
	current_state = pose_states[state_name]
	Globals.main_character_current_pose = state_name.replace("State", "")
	if current_state:
		current_state.enter(params)
	else:
		push_error("No pose state found %s" % state_name)

extends CharacterBody2D
class_name MainCharacterWithStates

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0
It incorporates the basic Godot CharacterBody2D movement and adds
the very needed features of:
	1. being able to hit Bodybuilding Poses
	2. Bein able to rip / put back on your clothes
	3. access to gui
It now has a state system. I dont know if this is the actual way to handle states but
I like it and it works.
"""

# State machine management
var current_state : State
var states : Dictionary = {} # holds references to state nodes

@export var footsteps : PackedScene
@export var godrays : PackedScene
@export var menu : Container
@export var gui : Gui
@export var vignette : ColorRect
@export var death_label : Label
@export var oil_label : OilLabel
@export var win_label : Label 
@export var easy_mode : Label
@export var endscreen : bool = false
@onready var feelings_label = $FeelingsLabel as Label
@onready var level_up_label = $LevelUpLabel as Label
@onready var player_animations = $PlayerAnimations as AnimatedSprite2D
@onready var keep_self_awareness_level_timer = $KeepSelfAwarenessLevelTimer as Timer

signal perfect_pose
signal bad_pose
signal enemy_defeated
signal trying_to_cheat

var self_awareness_loss_enabled : bool = false
var is_clothed : bool = false
var clothed_sadness_multiplier : float = 1.0
var switching_clothes : bool = false
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_animation : String = "Idle"
# This value is edited by walking close to enemy NPCs
var global_self_awareness_modifier : float = 0.0
var sad_sentences : Array[String] = ["I look like sh**", "life sucks", "What am I even doing", "Maybe I should just give up", "I guess this is it"]
var active_godray : bool = false
var collected_oil_bottles : int = 0
var enemies_nearby : int = 0
var game_finished : bool = false

func _ready():
	$PlayerAnimations.visible = true
	if endscreen:
		gui.visible = false
		is_clothed = Globals.is_clothed
	win_label.visible = false
	death_label.visible = false
	if material:
		material = material.duplicate()
	Globals.level_changed.connect(_on_level_up)
	init_states()
	# Start with the IdleState
	transition_to("IdleState")

func _process(delta):
	if current_state and not Globals.pause and not endscreen:
		current_state.process(delta)
		if self_awareness_loss_enabled:
			calculate_self_awareness_level(delta)
		set_sadness_panty_color()

func _physics_process(delta):
	if current_state and not Globals.pause:
		if not current_state.ignores_input() and not current_state == states["PoseState"]: #and not current_state == states["OilingState"]:
			if check_if_player_is_walking():
				transition_to("WalkState")
			elif velocity.x == 0:
				transition_to("IdleState")
		current_state.physics_process(delta)
		if switching_clothes and current_state == states["WalkState"]:
			velocity.x = 0.0
		apply_gravity(delta)
		move_and_slide()

func _unhandled_input(event):
	if not endscreen and menu.visible and event.is_action_pressed("option"):
		menu.visible = !menu.visible
		Globals.pause = menu.visible
	elif current_state and not switching_clothes and not Globals.pause:
		if not current_state.ignores_input():
			if not endscreen and event.is_action_pressed("option"):
				menu.visible = !menu.visible
				Globals.pause = menu.visible
			# Decided to go for a different kind of game, so i dont want to jump anymore.
			#elif event.is_action_pressed("jump") and is_on_floor() and not current_state == states["PoseState"]:
				#transition_to("JumpState", {"x_velocity": velocity.x})
				#return
			if not Globals.pause:
				# Oiling is finally back, i missed it
				if event.is_action_pressed("oil") and collected_oil_bottles > 0 and not Globals.oiled_up: # OIIILLL UP BOIIIII
					transition_to("OilingState")
					collected_oil_bottles -= 1
				elif is_pose_event(event):
					transition_to("PoseState", {"key_event": event})
				elif is_pose_event_release(event) and current_state == states["PoseState"]: # or event.is_action_released("oil"): Oiling doesnt exist anymore
					# var go_to_idle = true
					current_state.check_for_pose_event(event)
					if current_state == states["PoseState"]:
						var go_to_idle = current_state.register_current_pose(event)
						if go_to_idle:
							transition_to("IdleState")
		if not current_state == states["PoseState"]:
			if event.is_action_pressed("change"):
				switch_clothes()
		current_state.handle_input(event)
	elif Globals.pause and current_state == states["DeadState"]:
		if current_state.allow_return_to_main_menu() and event.is_action_pressed("oil"):
			get_tree().change_scene_to_file("res://Scenes/StartScreen.tscn")
	if game_finished and event.is_action_pressed("change"):
		Globals.is_clothed = is_clothed
		get_tree().change_scene_to_file("res://Scenes/EndScreen.tscn")
		
func transition_to(state_name: String, params = null):
	if is_clothed and state_name == "PoseState": #(state_name == "OilingState" or state_name == "PoseState"):
		switch_clothes()
		await get_tree().create_timer(0.5, false, false, false).timeout
	if switching_clothes:
		return
	if current_state:
		if current_state == states[state_name]:
			if params:
				current_state.update(params)
			return
		current_state.exit()
	else:
		push_warning("There is no active state, transitioning to %s" % state_name)
	current_state = states[state_name]
	if current_state:
		current_state.enter(params)
	else:
		push_error("No state found %s" % state_name)

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

# Will be called from states
func set_animation(animation_name: String):
	current_animation = animation_name
	player_animations.play(animation_name)
	
func check_if_player_is_walking() -> bool:
	if not current_state.ignores_input() and not Globals.tutorial:
		return Input.is_action_pressed("left") or Input.is_action_pressed("right")
	return false

func die(reason : String) -> void:
	if not endscreen:
		transition_to("DeadState", {"Message": reason})

func init_states():
	for child in get_children():
		if child is State:
			states[child.name] = child
			
func is_pose_event(event : InputEvent) -> bool:
	if event.is_action_pressed("abdominal") or event.is_action_pressed("back"):
		return true
	elif event.is_action_pressed("mosto") or event.is_action_pressed("side"):
		return true
	return false
	
func is_pose_event_release(event : InputEvent) -> bool:
	if event.is_action_released("abdominal") or event.is_action_released("back"):
		return true
	elif event.is_action_released("mosto") or event.is_action_released("side"):
		return true
	return false

# Function to handle oil_level loss
# Edit: Oil doesnt exist anymore. It is now self awareness.
# You may go back to one of the first commits to see how the character worked before
func calculate_self_awareness_level(delta) -> void:
	var self_awareness_level_modifier = Globals.get_self_awareness_modifier(is_clothed, global_self_awareness_modifier)
	if is_clothed:
		clothed_sadness_multiplier += clothed_sadness_multiplier * delta * 0.03
		self_awareness_level_modifier *= clothed_sadness_multiplier
	gui.add_self_awareness_level(self_awareness_level_modifier * delta)

func add_nearby_enemy_awareness_level(amount : float) -> void:
	global_self_awareness_modifier += amount
	
	
func switch_clothes() -> void:
	switching_clothes = true
	var animation : String = "strip" if is_clothed else "unstrip"
	current_animation = map_animations()
	player_animations.play(animation)
	
func map_animations() -> String:
	var animation_map = {
		"Idle": "Idle_clothes",
		"Idle_clothes": "Idle",
		"Walk": "Walk_clothes",
		"Walk_clothes": "Walk"
	}
	return animation_map.get(current_animation, current_animation)

func _is_basic_movement_event(event) -> bool:
	return is_pose_event_release(event) or event.is_action_released("left") or event.is_action_pressed("right") # or event.is_action_released("oil") 
	
func _on_player_animations_animation_finished():
	if player_animations.animation == "strip" or player_animations.animation == "unstrip":
		is_clothed = !is_clothed
		if is_clothed:
			clothed_sadness_multiplier = 1.0
			keep_self_awareness_level_timer.stop()
			self_awareness_loss_enabled = true
		switching_clothes = false
		set_animation(current_animation)


func _on_keep_self_awareness_level_timer_timeout():
	self_awareness_loss_enabled = true
	
func show_feelings() -> void:
	feelings_label.text = sad_sentences[randi_range(0,sad_sentences.size() - 1)]
	feelings_label.visible = true
	await get_tree().create_timer(4).timeout
	feelings_label.visible = false
	
func _on_level_up(level : int) -> void:
	level_up_label.visible = true
	await get_tree().create_timer(3.0).timeout
	level_up_label.visible = false
	if level == Globals.max_level:
		game_finished = true
		win_label.visible = true


func show_godrays():
	if not active_godray:
		var god_rays = godrays.instantiate()
		god_rays.global_position = Vector2(global_position.x - 225, global_position.y - 232)
		get_parent().add_child(god_rays)
		active_godray = true
		god_rays.setup(self)

func set_sadness_panty_color():
	var sadness = 1 - clampf(gui.get_self_awareness_level() / Globals.max_self_awareness_level, 0.0, 1.0)
	if material and not is_clothed:
		material.set("shader_parameter/darkening_factor", sadness)
	elif material and is_clothed:
		material.set("shader_parameter/darkening_factor", 0.0)
	if material and not Globals.sad:
		material.set("shader_parameter/darkening_factor", Color(0.0,227.0/255.0,185.0/255.0))
	if vignette.material:
		vignette.material.set("shader_parameter/intensity", 0.4 + sadness * 2)
		if not Globals.sad:
			easy_mode.visible = true
			vignette.material.set("shader_parameter/vignette_color", Color(38.0/255.0, 88.0/255.0, 98.0/255.0))
		else:
			vignette.material.set("shader_parameter/vignette_color", Color.BLACK)
			
func collect_oil_bottle():
	collected_oil_bottles = collected_oil_bottles + 1
	if collected_oil_bottles <= 0:
		collected_oil_bottles = 1
	oil_label.visible = true
	oil_label.change_oil_count(collected_oil_bottles)
	
func remove_oil_bottle():
	collected_oil_bottles = collected_oil_bottles - 1
	if collected_oil_bottles <= 0:
		collected_oil_bottles = 0
		oil_label.visible = false
	oil_label.change_oil_count(collected_oil_bottles)

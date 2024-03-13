class_name BasicEnemy
extends AnimatedSprite2D

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Basic enemy behaviour, making them easy to implement within the Inspector
"""

@onready var collision_shape_2d = $Area2D/CollisionShape2D as CollisionShape2D
@onready var area_2d = $Area2D as Area2D
@onready var self_esteem_bar = $SelfEsteemBar as CustomEnemyProgressBar
@onready var hint_label = $SelfEsteemBar/HintLabel as HintLabel
@onready var level_label = $SelfEsteemBar/LevelLabel as Label

@export var color_shader : bool = false
@export var level : int = 0
@export var dead : bool = false
@export_enum("Abdominal", "BackBizeps", "SideChest", "MostMuscular") var weakness : String
@export_range(0.5,3.0) var area_size : float = 1.0
@export_range(50,300) var max_self_esteem : int = 100
@export_range(0.0,5.0) var self_esteem_regen : float = 1.0
@export_range(0,50) var base_win_xp : int = 10
var self_esteem : float = 100.0
var strength_modifier : float = 0.0
var current_strength_modifier : float = 0.0
var player_pose_strength : float = 0.0
var noob_player : bool = false
var player_is_lame_modifier : float = 0.0
var player : MainCharacterWithStates = null
var last_player_pose : String = ""
var just_started_posing : bool = true
var player_saw_me : bool = false
signal death

# Called when the node enters the scene tree for the first time.
func _ready():
	if color_shader:
		_setup_shader()
	if dead:
		_die()
		area_2d.queue_free()
		ready()
		return
	self_esteem = float(max_self_esteem)
	self_esteem_bar.set_max_progress(max_self_esteem)
	add_self_esteem(max_self_esteem)
	_calculate_strength_difference(Globals.level)
	collision_shape_2d.scale = Vector2(area_size, area_size)
	Globals.level_changed.connect(_calculate_strength_difference)
	var overlapping_bodies = area_2d.get_overlapping_bodies()
	for body in overlapping_bodies:
		if _check_player_entered(body):
			break
	ready()
	
func ready() -> void:
	# use in inheriting classes
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not dead and not Globals.tutorial and not Globals.pause:
		var pose_strength = player_pose_strength if not noob_player else 5
		if player and not player.is_clothed:
			var current_pose = Globals.main_character_current_pose
			if Globals.main_character_posing and not (current_pose == last_player_pose and just_started_posing):
				player_is_lame_modifier = 0.0
				last_player_pose = current_pose
				if current_pose == weakness:
					if just_started_posing:
						noob_player = false
						player.show_godrays()
						hint_label.scared(weakness)
					var strength = player_pose_strength * 2 if player_pose_strength < 0 else player_pose_strength * 0.5
					if noob_player:
						strength = pose_strength * 2
					if Globals.oiled_up:
						pose_strength - Globals.oiled_up_modifier / 2
					add_self_esteem((current_strength_modifier + strength) * delta)
				else:
					if just_started_posing:
						noob_player = false
					add_self_esteem((current_strength_modifier + pose_strength) * delta)
				just_started_posing = false
			elif current_pose != last_player_pose:
				just_started_posing = true
				add_self_esteem(current_strength_modifier * delta + player_is_lame_modifier)
				player_is_lame_modifier += delta * 0.001
			else:
				if just_started_posing:
					hint_label.insult_player(current_pose)
				player_is_lame_modifier += delta * 0.01
				add_self_esteem((current_strength_modifier + player_pose_strength) * delta + player_is_lame_modifier)
				just_started_posing = false
			player_within_progress(delta)
		else:
			just_started_posing = true
			if not self_esteem == max_self_esteem:
				add_self_esteem(self_esteem_regen * delta)
			player_outside_progress(delta)
	elif dead and not Globals.tutorial and not Globals.pause:
		dead_progress(delta)
	
func player_within_progress(delta) -> void:
	# use in inheriting classes
	pass
	
func player_outside_progress(delta) -> void:
	# use in inheriting classes
	pass

func dead_progress(delta) -> void:
	# Used in Posing enemies.
	pass

func disabled_progress(delta) -> void:
	# Use for walking.
	pass

func _on_area_2d_body_entered(body):
	_check_player_entered(body)

func _check_player_entered(body) -> bool:
	if body is MainCharacterWithStates and not dead:
		player = body
		current_strength_modifier = strength_modifier
		player.add_nearby_enemy_awareness_level(current_strength_modifier)
		_on_player_entered(player)
		player.bad_pose.connect(_player_messed_up)
		player.perfect_pose.connect(_player_hit_perfect_pose)
		player.trying_to_cheat.connect(_absolute_noob)
		if not player_saw_me:
			player.enemies_nearby += 1
			player_saw_me = true
		return true
	return false
	
func _on_player_entered(player : MainCharacterWithStates) -> void:
	pass # Implement in actual enemies


func _on_area_2d_body_exited(body):
	if body is MainCharacterWithStates and not dead:
		player.add_nearby_enemy_awareness_level(-current_strength_modifier)
		player.perfect_pose.disconnect(_player_hit_perfect_pose)
		player.bad_pose.disconnect(_player_messed_up)
		player.trying_to_cheat.disconnect(_absolute_noob)
		player.enemies_nearby -= 1
		player_saw_me = false
		player = null
		_on_player_exited(body)
	
func _on_player_exited(player_body : MainCharacterWithStates) -> void:
	pass # Implement in actual enemies

func _calculate_strength_difference(player_level : int) -> void:
	if not dead:
		var level_difference = player_level - level
		if abs(level_difference) <= 2:
			level_label.text = str(level)
		elif level_difference < -2:
			level_label.text = "good luck"
		else:
			level_label.text = "pebble"
		var a = -0.03 if level_difference < 0 else 0.03
		var x = (a * level_difference * level_difference) - 1
		# Ensure the value is within the -6 to 6 to not completely destroy the player.
		strength_modifier = clamp(x, -6, 6)
		_calculate_pose_strength(level_difference)
	
func _calculate_pose_strength(level_difference : int) -> void:
	# This is linear, only to test for now.
	player_pose_strength = -(0.6 * level_difference + 2)
	
func _absolute_noob() -> void:
	noob_player = true
	
func add_self_esteem(value : float) -> float:
	self_esteem = clampf(self_esteem + value, 0.0, max_self_esteem)
	if self_esteem == max_self_esteem:
		self_esteem_bar.visible = false
	elif self_esteem == 0.0:
		_die()
	else:
		self_esteem_bar.visible = true
	self_esteem_bar.set_progress(self_esteem)
	return self_esteem
	
func _die() -> void:
	hint_label.dead()
	Globals.add_xp(base_win_xp * (level + 1))
	dead = true
	if player:
		player.add_nearby_enemy_awareness_level(-current_strength_modifier)
		player.perfect_pose.disconnect(_player_hit_perfect_pose)
		player.bad_pose.disconnect(_player_messed_up)
		player.enemy_defeated.emit()
		player.enemies_nearby = clampi(player.enemies_nearby - 1, 0, 1000)
	die()
	death.emit()
	await get_tree().create_timer(5).timeout
	queue_free()
	
func die():
	# Implement in inheriting classes
	pass
	
func _player_hit_perfect_pose() -> void:
	var hurts_much = (current_strength_modifier + player_pose_strength) * 10
	if hurts_much > 0:
		hurts_much *= -0.3
	add_self_esteem(hurts_much)
	pass

func _player_messed_up() -> void:
	add_self_esteem(15)
	hint_label.player_messed_up(last_player_pose)


func _setup_shader() -> void:
	"""
	Quite a complex function that just sets a lot of realistic random colors
	to the characters.
	"""
	if material:
		material = material.duplicate()
		# My try to get realistic skin colors
		var skin_color = Color(randf_range(0.7, 1.0), randf_range(0.5, 0.9), randf_range(0.4, 0.8), 1.0)
		material.set("shader_parameter/skin_color", skin_color)
		material.set("shader_parameter/skin_shading_color", darken_color(skin_color, 0.8))
		
		# Hair color
		var hair_color
		if randf() < 0.8:  # 80% chance to get natural hair color
			hair_color = Color(randf_range(0.0, 0.8), randf_range(0.0, 0.5), randf_range(0.0, 0.2), 1.0)
		else:  # 20% chance to get colored hair
			hair_color = Color(randf(), randf(), randf(), 1.0)
		material.set("shader_parameter/hair_color", hair_color)
		material.set("shader_parameter/hair_shading_color", darken_color(hair_color, 0.8))
		
		# Clothes color (any color, more saturated)
		var clothes_color = Color(randf(), randf(), randf(), 1.0)
		material.set("shader_parameter/clothes_color", clothes_color)
		material.set("shader_parameter/clothes_shading_color", darken_color(clothes_color, 0.8))
		
		# Shoes color (any color, less saturated)
		var shoes_color = Color(randf_range(0.0, 0.5), randf_range(0.0, 0.5), randf_range(0.0, 0.5), 1.0)
		material.set("shader_parameter/shoes_color", shoes_color)
		material.set("shader_parameter/shoes_shading_color", darken_color(shoes_color, 0.8))
		
		# Pants color (any color, normal saturation)
		var pants_color = Color(randf(), randf(), randf(), 1.0)
		material.set("shader_parameter/pants_color", pants_color)
		material.set("shader_parameter/pants_shading_color", darken_color(pants_color, 0.8))
	else:
		push_error("You didnt give %s a material but requested a shader change dumbass" % name)

# Used for Shadow colors
func darken_color(color: Color, factor: float) -> Color:
	return Color(color.r * factor, color.g * factor, color.b * factor, color.a)




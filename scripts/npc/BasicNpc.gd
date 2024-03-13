extends AnimatedSprite2D
class_name BasicNpc
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Basic Class that holds all people who are hidden first and then reveal
themselves to the player when he gets more self confident.
They all have a shader and are managed in NpcManager.gd

They also have a custom shader made to give them random colors,
They must have these colors for it to work correctly:
	0, 255, 255 -> Skin
	0, 200, 255 -> Skin shading
	255, 0, 0 -> Hair
	200, 0, 0 -> Hair shading
	0, 255, 0 -> Clothes
	0, 200, 0 -> Clothes shading
	255, 0, 255 -> shoes
	200, 0, 255 -> shoes shading
	0, 0, 255 -> Pants
	0, 0, 200 -> Pants shading
"""
# Previously i set the show at level in the inspector in game, would probably be smart for good placement
# Now i set it randomly based on position in _ready
#@export_range(1,69) var show_at_level : int = 69
var show_at_level : int = 0
@onready var do_random_things = $DoRandomThings as Timer
@onready var party_timer = $Party_timer as Timer
@export var shown = false
var xp_needed_to_reveal : int = 0

func _ready():
	# Map is 4500px wide, the further left or the further right the closer the npc level
	# will be to the max level
	var probable_level = clampi(int(clampf(abs(global_position.x) / 2500.0, 0.0, 1.0) * Globals.max_level), 1, Globals.max_level)
	show_at_level = randi_range(clampi(probable_level - 2, 0, probable_level), clampi(probable_level + 2, 0, Globals.max_level))
	# Helper setup for easy correct implementation of npcs.
	# idle and party should be looping, random should not be.
	var required_animations = ["idle", "random", "party"]
	for animation_string in required_animations:
		if not sprite_frames.has_animation(animation_string):
			push_error("The required animation '%s' is missing from the NPC %s." % [animation_string,name])
	xp_needed_to_reveal = Globals.calculate_xp(show_at_level - 1)
	_setup_shader()
	do_random_things.wait_time = randf_range(1.2, 10.0)
	update_shader(0)
	if shown:
		play("party")
		update_shader(6000000)
	ready()
	
func ready():
	# Implement in inheriting classes.
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_shader(xp : int) -> void:
	if not shown:
		var xp_proportions = float(xp) / float(xp_needed_to_reveal)
		var darkening_factor = 1.0 - clampf(pow(xp_proportions, 2), 0.0, 1.0)
		shown = darkening_factor == 0.0
		material.set("shader_parameter/darkening_factor", darkening_factor)


func _on_animation_finished():
	if animation == "random":
		play("idle")


func _on_do_random_things_timeout():
	play("random")
	do_random_things.wait_time = randf_range(1.2, 10.0)
	
func party_with_player() -> void:
	# When fully visible, they will party with player posing
	# Will be connected with when player starts posing, if he messes up
	# it will be reverted, if he hits it it continues playing untill he
	# either messes up or is not anymore in battle
	party_timer.stop()
	do_random_things.stop()
	play("party")
	party_timer.start(randf_range(1.2,7.5))
	

func _setup_shader() -> void:
	"""
	Quite a complex function that just sets a lot of realistic random colors
	to the characters.
	"""
	if material:
		material = material.duplicate()
		# My try to get realistic skin colors
		var skin_color
		var skin_type = randi() % 3  # Randomly choose a skin type
		match skin_type:
			0:  # Light skin tones
				skin_color = Color(randf_range(0.8, 1.0), randf_range(0.7, 0.9), randf_range(0.6, 0.8), 1.0)
			1:  # Medium skin tones
				skin_color = Color(randf_range(0.6, 0.8), randf_range(0.4, 0.6), randf_range(0.3, 0.5), 1.0)
			2:  # Dark skin tones
				skin_color = Color(randf_range(0.3, 0.5), randf_range(0.2, 0.4), randf_range(0.1, 0.3), 1.0)
			
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
		
		# Random brownish hidden color
		var random_dark_color = Vector3(randf_range(0.17, 0.23), randf_range(0.09, 0.11), randf_range(0.0, 0.01))
		material.set("shader_parameter/hidden_color", random_dark_color)
	else:
		push_error("You didnt give %s a material but requested a shader change dumbass" % name)

# Used for Shadow colors
func darken_color(color: Color, factor: float) -> Color:
	return Color(color.r * factor, color.g * factor, color.b * factor, color.a)


func _on_party_timer_timeout():
	play("idle")
	do_random_things.start(randf_range(1.2, 10.0))

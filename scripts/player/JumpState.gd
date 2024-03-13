"""
Deprecated
extends State

You jumped with this script, which is not needed to get
the full game experience, so i removed it again

var just_entered : bool = false
var jump_completed : bool = false
var speed : float = 0
var last_x_velocity : float = 0

func enter(params = {"x_velocity": 0}):
	if params and "x_velocity" in params:
		last_x_velocity = params["x_velocity"]
	speed = Globals.player_aerial_walk_speed
	just_entered = true
	jump_completed = false
	update_animation()
	
func exit():
	player.velocity.x = move_toward(player.velocity.x, 0, Globals.player_walk_speed)
	
func physics_process(delta):
	if just_entered:
		player.velocity.y = -Globals.player_jump_velocity
		just_entered = false
	elif player.is_on_floor():
		jump_completed = true
		exit()
		return
	var direction = Input.get_axis("left", "right")
	last_x_velocity += direction * speed * delta
	player.velocity.x = last_x_velocity
	if direction != 0:
		player.player_animations.flip_h = direction < 0
	
func ignores_input() -> bool:
	return not jump_completed

func update_animation() -> void:
	pass
"""

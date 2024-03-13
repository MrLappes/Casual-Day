extends State

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

Thanks to this, the character doesnt just stay in one place.
You also have some epic footstep particles spawning.
"""

var is_clothed: bool = false
var walk_speed : float = 300.0
var footsteps : PackedScene
var last_step : int = -1
@onready var player_animations = $"../PlayerAnimations" as AnimatedSprite2D
@onready var audio_stream_player_2d = $"../AudioStreamPlayer2D"


func _ready():
	footsteps = player.footsteps

func enter(_params = null):
	last_step = -1
	walk_speed = Globals.player_walk_speed
	update_animation()

func exit():
	player.velocity.x = move_toward(player.velocity.x, 0, walk_speed)
	
	
func physics_process(_delta):
	var direction = Input.get_axis("left", "right")
	player.velocity.x = direction * walk_speed
	if direction != 0:
		player.player_animations.flip_h = direction < 0
	handle_footstep_particles()

func update_animation() -> void:
	if player.is_clothed:
		player.set_animation("Walk_clothes")
	else:
		player.set_animation("Walk")
		
func handle_footstep_particles() -> void:
	# Very important weird green step particles
	if(player_animations.frame == 0 or player_animations.frame == 2):
		if(last_step != player_animations.frame):
			last_step = player_animations.frame
			var footstep = footsteps.instantiate()
			footstep.global_position = Vector2(player.global_position.x, player.global_position.y + 20)
			player.get_parent().add_child(footstep)
			footstep.emitting = true
			audio_stream_player_2d.play()

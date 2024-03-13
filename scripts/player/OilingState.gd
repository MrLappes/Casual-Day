extends State
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0


This was previously used as there was no self esteem bar, but instead an oil bar
where the player had to be oiled up at any time to not die.
Was fun but I didn't really know how to continue. You may snatch this script if you want though.

Now it has been modified to oil up the player when he has collected some oil and presses [Q]
Oiling will extremely increase the self esteem level whilst oiling up and afterwards boost self esteem
for 20 seconds untill it goes away again.
"""
@onready var oil_particles = $OilParticles as GPUParticles2D
@onready var oiling_timer = $OilingTimer as Timer
@onready var oilsplash = $oilsplash as AudioStreamPlayer2D
var oil_modifier_time : float = 20.0
var base_oiled_modifier : float = 5
var oiling_up_modifier : float = 10
var oiled_up : bool = false

func enter(_params = null):
	if not Globals.oiled_up:
		oilsplash.play()
		oil_particles.emitting = true
		oiled_up = false
		player.is_clothed = false
		player.remove_oil_bottle()
		Globals.oiled_up_modifier = oiling_up_modifier
		Globals.oiled_up = true
		oiling_timer.start(3.0)
		update_animation()
	else:
		exit()
	
func ignores_input() -> bool:
	# Hahaa I have another use case for this function again :)
	return not oiled_up
	
 
func exit():
	pass

func update_animation() -> void:
	player.set_animation("Oil")


func _on_oiling_timer_timeout():
	if not oiled_up:
		oiled_up = true
		Globals.oiled_up_modifier = base_oiled_modifier
		oiling_timer.start(20.0)
	else:
		oiled_up = false
		Globals.oiled_up = false
		oil_particles.emitting = false

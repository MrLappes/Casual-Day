extends State

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

If you see this state ingame, you suck.
"""

var allow_return = false

func enter(params = {"Message": "You died."}):
	var death_label_text : String = ""
	if params and "Message" in params:
		death_label_text = params["Message"]
	Globals.dead = true
	allow_return = false
	player.death_label.text = death_label_text
	player.gui.visible = false
	player.set_animation("death_clothes" if player.is_clothed else "death")
	Globals.pause = true
	player.keep_self_awareness_level_timer.stop()
	await get_tree().create_timer(2.0, false, false, false).timeout
	allow_return = true
	player.death_label.visible = true
	Audio.transition_play_moosic("Player Sucks")
	
func allow_return_to_main_menu() -> bool:
	return allow_return

func _on_player_animations_animation_finished():
	if player.player_animations.animation == "death":
		$"../PlayerAnimations".visible = false
		

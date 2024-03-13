extends Label
class_name HintLabel

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

This insults or praises the player for fighting fair and square
Is shown above current enemy head depending on how the player poses
"""

@onready var insult_timer = $InsultTimer as Timer

var anti_insults : Array[String] = ["DAMN your POSE looks epic", "I have underestimated your POSE", ":o"]
var insults : Array[String] = ["Cant do anything except hitting a POSE i guess", "POSE is the only thing you know?", "On second glance, your looks suck."]
var dead_texts : Array[String] = ["I can't keep up with these looks", "Your muscles are just superior", "I didn't stand a chance", "You can't be natty"]
var messed_up_insults : Array[String] = ["Can't even hit a POSE pose correctly", "You suck", "Is holding it for 7 seconds that hard?", "Come on, I am here for a show"]

func _ready():
	visible = false

func insult_player(last_player_pose : String) -> void:
	insult_timer.stop()
	var insult_text = insults[randi_range(0, insults.size() - 1)]
	text = insult_text.replace("POSE", last_player_pose)
	visible = true
	insult_timer.start(4)


func scared(pose : String) -> void:
	insult_timer.stop()
	var anti_insult_text = anti_insults[randi_range(0, anti_insults.size() - 1)]
	text = anti_insult_text.replace("POSE", pose)
	visible = true
	insult_timer.start(4)
	
func dead() -> void:
	insult_timer.stop()
	text = dead_texts[randi_range(0, dead_texts.size() - 1)]
	visible = true
	insult_timer.start(6)
	
func player_messed_up(pose : String) -> void:
	insult_timer.stop()
	var messed_up_text = messed_up_insults[randi_range(0, messed_up_insults.size() - 1)]
	text = messed_up_text.replace("POSE", pose)
	visible = true
	insult_timer.start(4)

func _on_insult_timer_timeout():
	visible = false

extends Sprite2D
class_name OilFlask
"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

This just manages collecting of oil_flasks
"""
signal deletion_queued
@onready var collectable_range = $CollectableRange as Area2D
@onready var pickup_label = $PickupLabel as Label

var player : MainCharacterWithStates = null

func _ready():
	for body in collectable_range.get_overlapping_bodies():
		if body is MainCharacterWithStates:
			player = body
	if not player:
		pickup_label.visible = false

func _unhandled_key_input(event):
	if player and event.is_action_pressed("collect"):
		player.collect_oil_bottle()
		print(player.collected_oil_bottles)
		deletion_queued.emit()
		queue_free()

func _on_collectable_range_body_entered(body):
	if body is MainCharacterWithStates:
		player = body
		pickup_label.visible = true

func _on_collectable_range_body_exited(body):
	if body is MainCharacterWithStates:
		player = null
		pickup_label.visible = false

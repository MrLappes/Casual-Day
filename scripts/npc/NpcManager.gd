extends Node

"""
This Script was written by MrLappes for the Acerola Game Jam #0
https://itch.io/jam/acerola-jam-0

This script controls NPC party!
And visibility
"""
@export var endscreen : bool = false
var npc_list : Array[BasicNpc] = []
var base_hidden_color : Color = Color(0.2,0.1,0.0)
@onready var player= $"../PlayerWStatesTest" as MainCharacterWithStates

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.xp_changed.connect(_update_shader_visibility)
	_findNpcs(get_parent())
	if not player:
		player = get_parent().find_child("Player")
	player.perfect_pose.connect(_make_everyone_pose)
	
func _findNpcs(node) -> void:
	if node is BasicNpc:
		npc_list.push_back(node)
	for child in node.get_children():
		_findNpcs(child)

func _make_everyone_pose() -> void:
	for npc in npc_list:
		if npc.shown or endscreen:
			npc.party_with_player()

func _update_shader_visibility(xp : int) -> void:
	for npc in npc_list:
		npc.update_shader(xp)

extends Node

@onready var oil_flask = $OilFlask


# Called when the node enters the scene tree for the first time.
func _ready():
	oil_flask.visible = false
	


func _on_robber_death():
	oil_flask.visible = true


func _on_oil_flask_deletion_queued():
	queue_free()

extends StaticBody2D

func remove_this() -> void:
	queue_free()


func _on_robber_death():
	remove_this()

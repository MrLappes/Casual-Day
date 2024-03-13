extends BasicEnemy


func ready():
	play("move_eyes")
	
func die():
	play_backwards("rob")

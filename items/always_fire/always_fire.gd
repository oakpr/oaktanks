extends Item

func tick(_delta):
	emit_signal("fire", 0)
	emit_signal("fire", 1)
	emit_signal("fire", 2)

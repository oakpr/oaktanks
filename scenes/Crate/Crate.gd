extends RigidBody
class_name Crate


# Declare member variables here. Examples:
var health = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(damage):
	health -= damage
	if health <= 0:
		get_tree().queue_delete(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Item
class_name DummyItem

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Returns the position the item wants to be sorted in, and controls the order in which it is executed. Higher numbers run first.
func order_priority() -> float:
	return 10.0

func fire_priority() -> float:
	return 10.0

func fire_rate() -> float:
	return 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

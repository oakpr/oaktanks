extends Item
class_name DummyItem

# Odds that an item pickup will be spawned when the parent is killed
func drop_rate() -> float:
	return .7

# Returns the position the item wants to be sorted in, and controls the order in which it is executed. Higher numbers run first.
func order_priority() -> float:
	return 10.0

func fire_priority() -> float:
	return 10.0

func fire_rate() -> float:
	return 0.1

func damage() -> float:
	return 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

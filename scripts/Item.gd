extends Node
class_name Item

# Returns the position the item wants to be sorted in, and controls the order in which it is executed. Higher numbers run first.
func order_priority() -> float:
	return -INF

# Returns the priority of the item for movement purposes. If this is the highest priority, this will overwrite the tank's movement.
func control_priority() -> float:
	return -INF

func controls() -> Vector2:
	return Vector2.ZERO

# Returns the priority of the item for aiming purposes. If this is the highest priority, this will overwrite the tank's aim.
func aim_point_priority() -> float:
	return -INF

func aim_point() -> Vector2:
	return Vector2.ZERO

func speed(current: float) -> float:
	return current

func tick(_delta: float):
	pass

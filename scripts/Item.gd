extends Node
class_name Item

# Returns the position the item wants to be sorted in, and controls the order in which it is executed. Higher numbers run first.
func order_priority() -> float:
	return -INF

# Returns the priority of the item for movement purposes. If this is the highest priority, this will overwrite the tank's movement.
func control_priority() -> float:
	return -INF

# Returns the priority of the item for movement purposes. If this is the highest priority, this will overwrite the tank's weapon.
func fire_priority() -> float:
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

func calculate_gfx(gfx: Spatial) -> Spatial:
	return gfx

# Method to move an Item to a new parent
# target is the new parent node
func reparent(target: Node) -> void:
	var least_greater = INF
	var previous
	if get_parent():
		# nodes can't have two parents either
		get_parent().remove_child(self)
	for node in target.get_children():
		if node.get_class() != "Item":
			previous = node
			continue
		least_greater = min(least_greater, node.order_priority())
		if least_greater < order_priority():
			break
		previous = node
	target.add_child_below_node(previous, self)
	print(target.get_children())
	return

func get_class() -> String:
	return "Item"

func tank_parent():
	var parent = get_parent()
	if parent.get_class() == "Item":
		return parent
	if parent.get_class() == "Tank":
		return parent
	return null

func tick(_delta: float):
	pass

extends Item

export var color: Color = Color.black

# Returns the position the item wants to be sorted in, and controls the order in which it is executed. Higher numbers run first.
func order_priority() -> float:
	return 11.0

# this is awful, we should rewrite this once we have a way to react to new items!
func _ready():
	yield(get_tree(),"idle_frame")
	get_parent().border_mat.set_shader_param("outline_color", color)

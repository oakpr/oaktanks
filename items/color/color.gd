extends Item

export var color: Color = Color.black

# this is awful, we should rewrite this once we have a way to react to new items!
func _ready():
	yield(get_tree(),"idle_frame")
	get_parent().border_mat.set_shader_param("outline_color", color)

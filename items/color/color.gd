extends Item

export var color: Color = Color.black

# Returns the position the item wants to be sorted in, and controls the order in which it is executed. Higher numbers run first.
func order_priority() -> float:
	return 11.0

func calculate_gfx(gfx: Spatial) -> Spatial:
	return node_visitor(gfx)

func node_visitor(node: Spatial) -> Spatial:
	for child in node.get_children():
		node_visitor(child)
	if node is MeshInstance:
		for material in range(node.get_surface_material_count()):
			node.set_surface_material(material, shader_visitor(node.get_surface_material(material)))
		for material in range(node.mesh.get_surface_count()):
			node.mesh.surface_set_material(material, shader_visitor(node.mesh.surface_get_material(material)))
	return node

func shader_visitor(shader: Material) -> Material:
	if !shader:
		return shader
	if shader.next_pass:
		shader.next_pass = shader_visitor(shader.next_pass)
	else:
		var border = preload("res://scenes/tank/tank_outline.tres").duplicate(true)
		border.set_shader_param("outline_color", color)
		shader.next_pass = border
	return shader

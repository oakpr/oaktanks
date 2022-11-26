extends Item

const gfx_scene = preload("res://items/basic_tank_gfx/basic_tank.tscn")

func order_priority():
	return 0

func calculate_gfx(gfx: Spatial) -> Spatial:
	var source = gfx_scene.instance()
	for child in source.get_children():
		source.remove_child(child)
		gfx.add_child(child)
	return gfx

func _process(_delta):
	var body = $"../Graphics/body"
	var tank_body = $"../body"
	var turret = $"../Graphics/turret"
	var tank_turret = $"../turret"
	var gun = $"../Graphics/turret/gun_parent/gun"
	var tank_gun = $"../turret/gun_parent/gun"
	if body:
		body.transform = tank_body.transform
	if turret:
		turret.transform = tank_turret.transform
	if gun:
		gun.transform = tank_gun.transform

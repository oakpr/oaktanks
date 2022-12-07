extends Item

func aim_point_priority() -> float:
	return 0.0

func aim_point() -> Vector2:
	var my_pos = get_tank().transform.origin
	var nearest_enemy = null
	for tank in get_tree().get_nodes_in_group("tank"):
		if !tank is Tank || tank.team == get_tank().team:
			continue
		if nearest_enemy == null || my_pos.distance_to(tank.transform.origin) < my_pos.distance_to(nearest_enemy):
			nearest_enemy = tank.transform.origin
	var aim3 = nearest_enemy - my_pos
	return Vector2(aim3.x, aim3.z)

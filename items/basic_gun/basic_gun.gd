extends Item

var reload = 0
var fire_interval = 1.1
var damage = 1

func tick(delta):
	reload -= delta
	reload = max(reload, 0)

func fire(node: Spatial, index: int) -> Spatial:
	if index != 0 || reload > 0:
		return node;
	var shell = preload("res://scenes/Cannonball/Cannonball.tscn").instance()
	# Start our shell inside the gun barrel
	shell.transform = get_tank().gun.global_transform
	# Move it up to the front though
	shell.transform.origin += shell.transform.basis.y * 0.5
	shell.bullet_owner = get_tank().team
	shell.add_collision_exception_with(get_tank())
	shell.linear_velocity = shell.transform.basis.y * 20
	shell.damage = damage
	node.add_child(shell)
	reload = fire_interval
	$SoundAttack.play()
	return node

extends KinematicBody

export var controls = Vector2.ZERO
export var aim_point = Vector2.UP
export var history_max_length = 0.25
export var base_speed = 3

onready var body: MeshInstance = $body
onready var turret: MeshInstance = $turret
onready var gun: MeshInstance = $turret/gun_parent/gun
onready var body_mat: Material = body.get_surface_material(0).duplicate()
onready var turret_mat: Material = turret.get_surface_material(0).duplicate()
onready var gun_mat: Material = gun.get_surface_material(0).duplicate()
onready var border_mat: ShaderMaterial = body_mat.next_pass.duplicate()
var movement_history = []

func _ready():
	body.set_surface_material(0, body_mat)
	turret.set_surface_material(0, turret_mat)
	gun.set_surface_material(0, gun_mat)
	body_mat.next_pass = border_mat
	pass # Replace with function body.

# Normalize an angle in degrees to a [-180,180] range
func normalize_deg(theta: int):
	return -((-theta+180)%360) + 180

# Find the difference between two angles in degrees, nicely
func abs_diff_deg(theta: int, phi: int):
	return abs(abs(normalize_deg(theta)) - abs(normalize_deg(phi)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Run items
	var best_control_priority = -INF
	var best_aim_point_priority = -INF
	var speed = base_speed
	for item in get_children():
		if !(item is Item):
			continue
		if item.control_priority() > best_control_priority:
			controls = item.controls()
			best_control_priority = item.control_priority()
		if item.aim_point_priority() > best_aim_point_priority:
			aim_point = item.aim_point()
			best_aim_point_priority = item.aim_point_priority()
		speed = item.speed(speed)
	# Spring the gun back into place
	gun.transform.origin.z = lerp(gun.transform.origin.z, 0, min(delta * 20, 1))
	# Rotate the turret toward the aim point
	if aim_point != Vector2.ZERO:
		turret.rotation.y = lerp_angle(turret.rotation.y, (aim_point * Vector2(1, -1)).angle() + PI / 2, min(delta * 20, 1))
	# If movement is nonzero...
	if controls != Vector2.ZERO:
		# radians CCW from -y (north)
		var goal_direction = (controls * Vector2(1, -1)).angle() - PI / 2
		# difference in degrees between current and goal direction
		var norm_diff = abs_diff_deg(rad2deg(goal_direction), rad2deg(body.rotation.y))
		if norm_diff > 60:
			speed = 0
		body.rotation.y = lerp_angle(body.rotation.y, goal_direction, min(delta * 8, 1))
		# normalize into a range -PI to +PI radians
		if body.rotation.y > PI:
			body.rotation.y -= TAU
		if body.rotation.y < -PI:
			body.rotation.y += TAU
		move_and_slide(Vector3.FORWARD.rotated(Vector3.UP, body.rotation.y) * min(controls.length(), 1) * speed)
	pass

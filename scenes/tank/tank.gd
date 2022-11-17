extends KinematicBody

export var controls = Vector2.ZERO
export var aim_point = Vector2.UP
export var history_max_length = 0.25
export var base_speed = 3

onready var body: Spatial = $body
onready var turret: Spatial = $turret
onready var gun: Spatial = $turret/gun_parent/gun

var movement_history = []

func _ready():
	pass # Replace with function body.


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
		var goal_direction = (controls * Vector2(1, -1)).angle() - PI / 2
		body.rotation.y = lerp_angle(body.rotation.y, goal_direction, min(delta * 8, 1))
		move_and_slide(Vector3.FORWARD.rotated(Vector3.UP, body.rotation.y) * min(controls.length(), 1) * speed)
	pass

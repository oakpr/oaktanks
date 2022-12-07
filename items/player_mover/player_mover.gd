extends Item

var movement = Vector2.ZERO
var aim = Vector2.ZERO
var use_joystick = false

func _process(_delta):
	# Get movement axis
	movement = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	aim = Vector2(
		Input.get_axis("aim_left", "aim_right"),
		Input.get_axis("aim_up", "aim_down")
	)
	if aim == Vector2.ZERO:
		if !use_joystick || Input.is_mouse_button_pressed(1): # normalize mouse position to XZ plane
			use_joystick = false
			var position3: Vector3 = get_parent().global_transform.origin
			var position2 = Vector2(
				position3.x,
				position3.z
			)
			var mouse_screen_pos = get_viewport().get_mouse_position()
			var mouse_position = get_viewport().get_camera().project_position(mouse_screen_pos, 0)
			var camera_normal = get_viewport().get_camera().project_ray_normal(mouse_screen_pos).normalized()
			var angle = atan2(camera_normal.y, sqrt(pow(camera_normal.x, 2.0) + pow(camera_normal.z, 2.0)))
			var length = (mouse_position.y - 0.3) / sin(angle)
			mouse_position -= camera_normal.normalized() * length
			var mouse_position2 = Vector2(
				mouse_position.x,
				mouse_position.z
			)
			aim = (mouse_position2 - position2).normalized()
	else:
		use_joystick = true
	if Input.is_action_pressed("fire"):
		emit_signal("fire", 0)

# Returns the position the item wants to be sorted in, and controls the order in which it is executed. Higher numbers run first.
func order_priority() -> float:
	return 12.0

func control_priority() -> float:
	if movement.length() > 0.3:
		return 0.0;
	elif movement.length() > 0.0:
		return -1.0;
	else:
		return -9998.0;

func controls() -> Vector2:
	return movement

func aim_point_priority() -> float:
	return 0.0;

func aim_point() -> Vector2:
	return aim;


extends KinematicBody
class_name Tank

export var controls = Vector2.ZERO
export var aim_point = Vector2.UP
export var history_max_length = 0.25
export var base_speed = 3

onready var body: Spatial = $body
onready var turret: Spatial = $turret
onready var gun: Spatial = $turret/gun_parent/gun
onready var body_mat: Material = body.get_surface_material(0).duplicate()
onready var turret_mat: Material = turret.get_surface_material(0).duplicate()
onready var gun_mat: Material = gun.get_surface_material(0).duplicate()
onready var border_mat: ShaderMaterial = body_mat.next_pass.duplicate()

const music_mode = false

var movement_history = []
var damage = 0
var firing = false
var reload = 0
var fire_rate = .5
var health_max = 200
var health = health_max

func _ready():
	OS.window_fullscreen = true
	body.set_surface_material(0, body_mat)
	turret.set_surface_material(0, turret_mat)
	gun.set_surface_material(0, gun_mat)
	body_mat.next_pass = border_mat

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Run items
	var best_control_priority = -INF
	var best_aim_point_priority = -INF
	var best_fire_priority = -INF
	var speed = base_speed
	for item in get_children():
		if item.get_class() != "Item":
			continue
		if item.control_priority() > best_control_priority:
			controls = item.controls()
			best_control_priority = item.control_priority()
		if item.aim_point_priority() > best_aim_point_priority:
			aim_point = item.aim_point()
			best_aim_point_priority = item.aim_point_priority()
		if item.fire_priority() > best_fire_priority:
			# add some code here to actually use the Item
			# can we point the Tank's fire method at an Item's?
			if item.has_method("fire_rate"):
				fire_rate = item.fire_rate()
			if item.has_method("damage"):
				damage = item.damage()
			best_fire_priority = item.fire_priority()
		speed = item.speed(speed)
		item.tick(delta)
	# Spring the gun back into place
	gun.transform.origin.z = lerp(gun.transform.origin.z, 0, min(delta * 20, 1))
	# Rotate the turret toward the aim point
	if aim_point != Vector2.ZERO:
		turret.rotation.y = lerp_angle(turret.rotation.y, (aim_point * Vector2(1, -1)).angle() + PI / 2, min(delta * 20, 1))
	# If movement is nonzero...
	if controls != Vector2.ZERO:
		var goal_direction = (controls * Vector2(1, -1)).angle() - PI / 2
		body.rotation.y = lerp_angle(body.rotation.y, goal_direction, min(delta * 8, 1))
		var forward = Vector3.FORWARD.rotated(Vector3.UP, body.rotation.y)
		move_and_slide(forward * min(controls.length(), 1) * pow(controls.normalized().dot(Vector2(forward.x, forward.z).normalized()), 2) * speed)
	# Slow health regen
	health = min(health_max, health + 1 * delta)
	$HealthLabel.text = String(int(health))
	# Reload the gun
	if reload > 0:
		reload -= delta
	if firing:
		fire()

func fire():
	# Shooting
	if reload <= 0:
		var shell = preload("res://scenes/Cannonball/Cannonball.tscn").instance()
		get_parent().add_child(shell)
		# Start our shell inside the gun barrel
		shell.transform = gun.global_transform
		# Maybe move it up to the front though ;)
		shell.transform.origin += shell.transform.basis.y * 0.5
		shell.bullet_owner = self.get_name()
		shell.add_collision_exception_with(self)
		shell.linear_velocity = shell.transform.basis.y * 20
		if damage:
			shell.damage = damage
		reload = fire_rate
		$SoundAttack.play()

func _input(event):
	if event is InputEventMouseButton or event is InputEventJoypadButton:
		firing = !firing

func _on_Tank_child_entered_tree(node):
	if node.get_class() == "Item":
		# Handle new items here
		print(node.tank_parent())

func get_class() -> String:
	return "Tank"

func take_damage(damage: int):
	if damage <= 0:
		return
	health -= damage
	if health <= 0:
		# Game over
		$SoundDeath.play()
		get_tree().queue_delete(self)
	$HealthLabel.text = String(int(health))

func _on_MusicPlayer_beat(n):
	if music_mode:
		fire()

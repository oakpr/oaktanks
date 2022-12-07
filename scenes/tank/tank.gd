extends KinematicBody
class_name Tank

export var controls = Vector2.ZERO
export var aim_point = Vector2.UP
export var history_max_length = 0.25
export var base_speed = 3
export var team = 0
export var type = "?"

onready var body: Spatial = $body
onready var turret: Spatial = $turret
onready var gun: Spatial = $turret/gun_parent/gun

var movement_history = []
export var health_max = 200
var health = health_max
var gfx: Spatial

func _ready():
	recalculate_gfx()

func recalculate_gfx():
	if gfx:
		gfx.free()
	gfx = Spatial.new()
	gfx.name = "Graphics"
	for item in get_children():
		item.connect("fire", self, "fire")
		if item.get_class() != "Item":
			continue
		gfx = item.calculate_gfx(gfx)
	add_child(gfx)

func add_item(item_taken: Item):
	item_taken.reparent(self)
	recalculate_gfx()

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
#	$HealthLabel.text = String(int(health))

func fire(index: int):
	var node = Spatial.new()
	for child in get_children():
		if child.get_class() != "Item":
			continue
		node = child.fire(node, index)
	for child in node.get_children():
		if child is Spatial:
			var t = child.transform
			node.remove_child(child)
			get_parent().add_child(child)
			child.global_transform = t
		else:
			get_parent().add_child(child)
			node.remove_child(child)
	pass

func _on_Tank_child_entered_tree(node):
	if node.get_class() == "Item":
		# Handle new items here
		print(node.get_tank())

func get_class() -> String:
	return "Tank"

func take_damage(damage: int):
	if damage <= 0:
		return
	health -= damage
	if health <= 0:
		# Game over; crash the game. No losers allowed
		$SoundDeath.play()
		get_tree().queue_delete(self)
#	$HealthLabel.text = String(int(health))

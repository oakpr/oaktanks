extends RigidBody
class_name Tower

onready var body: Spatial = $body
onready var turret: Spatial = $turret
onready var gun: Spatial = $turret/gun_parent/gun

# Declare member variables here. Examples:
var health = 25
var player
var reload = 0
var fire_rate = 1.2
var team = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	player = get_parent().get_node("Player")
	fire_rate += randf()

func take_damage(damage):
	health -= damage
	if health <= 0:
		for node in get_children():
			if node.get_class() != "Item":
				continue
			if randf() <= node.drop_rate():
				var box = preload("res://scenes/ItemBox/ItemBox.tscn").instance()
				get_parent().add_child(box)
				node.reparent(box)
				box.transform = body.global_transform
		$SoundDeath.play()
		get_tree().queue_delete(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	aim()
	# Spring the gun back into place
	gun.transform.origin.z = lerp(gun.transform.origin.z, 0, min(delta * 20, 1))
	# Reload the gun
	if reload > 0:
		reload -= delta
	# Shooting
	if reload <= 0:
		var shell = preload("res://scenes/Cannonball/Cannonball.tscn").instance()
		get_parent().add_child(shell)
		# Start our shell inside the gun barrel
		shell.transform = gun.global_transform
		# Maybe move it up to the front though ;)
		shell.transform.origin += shell.transform.basis.y * 0.5
		shell.bullet_owner = self.team
		shell.add_collision_exception_with(self)
		shell.linear_velocity = shell.transform.basis.y * 16
		reload += fire_rate
		$SoundAttack.play()

func aim():
	var target: Vector3 = player.global_transform.origin
	target.y = turret.global_transform.origin.y
	turret.look_at(target, Vector3.UP)

extends RigidBody
class_name ScaryTower

onready var body: Spatial = $body
onready var turret: Spatial = $turret
onready var guna: Spatial = $turret/gun_parent/guna
onready var gunb: Spatial = $turret/gun_parent/gunb
onready var gun_loc = [guna, gunb]

# Declare member variables here. Examples:
var health = 25
var player
var reload = 0
var fire_rate = .08
var next_gun = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")

func take_damage(damage):
	health -= damage
	if health <= 0:
		get_tree().queue_delete(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	aim()
	# Spring the gun back into place
	guna.transform.origin.z = lerp(guna.transform.origin.z, 0, min(delta * 20, 1))
	# Reload the gun
	if reload > 0:
		reload -= delta
	# Shooting
	if reload <= 0:
		var shell = preload("res://scenes/Cannonball/Cannonball.tscn").instance()
		get_parent().add_child(shell)
		# Start our shell inside the gun barrel
		shell.transform = gun_loc[next_gun].global_transform
		# Maybe move it up to the front though ;)
		shell.transform.origin += shell.transform.basis.y * 0.5
		shell.bullet_owner = self.get_name()
		shell.add_collision_exception_with(self)
		shell.linear_velocity = shell.transform.basis.y * 16
		reload += fire_rate
		next_gun ^= 1

func aim():
	var target: Vector3 = player.global_transform.origin
	target.y = turret.global_transform.origin.y
	turret.look_at(target, Vector3.UP)

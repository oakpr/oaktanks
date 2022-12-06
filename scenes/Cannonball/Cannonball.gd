extends RigidBody

# Declare member variables here. Examples:
var velocity = Vector3.ZERO
var speed = 20
var bullet_owner = 0
var damage

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _physics_process(delta):
	#velocity = transform.basis.y * speed
	#transform.origin += velocity * delta
	pass

# Called when the bullet collides with another body
func _on_Cannonball_body_entered(body):
	if body is Tank && body.team != bullet_owner:
		if damage and body.has_method("take_damage"):
			damage = int(rand_range(1, damage))
			body.take_damage(damage)
	_on_Timer_timeout()

# Called the bullet has traveled its max range
func _on_Timer_timeout():
	get_tree().queue_delete(self)

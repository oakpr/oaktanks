extends KinematicBody

# Declare member variables here. Examples:
onready var body: MeshInstance = $body
onready var mesh: PrismMesh = body.get("mesh")
var time = 0
var stash = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# replace this with child nodes that inherit Item 
	var cool_sword = "cool_sword"
	stash.push_front(cool_sword)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * 10
	mesh.left_to_right = sin(time) * .75 + .5
	body.rotation_degrees.y += delta * 60

# called when another Area enters this Area
func _on_Box_area_entered(area: Area):
	if area.name == "PickupZone":
		# replace this with:
		#for loot in get_childen():
		for loot in stash:
			if loot is Item:
				area.get_parent().add_item(loot)
			else:
				print(loot + " moved to player")
		get_tree().queue_delete(self)

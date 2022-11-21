extends KinematicBody

# Declare member variables here. Examples:
onready var body: MeshInstance = $body
onready var mesh: PrismMesh = body.get("mesh")
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# replace this with child nodes that inherit Item 
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * 10
	mesh.left_to_right = sin(time) * .75 + .5
	body.rotation_degrees.y += delta * 60

# called when another Area enters this Area
func _on_Box_area_entered(area: Area):
	if area.name == "PickupZone":
		for loot in get_children():
			if !(loot is Item):
				continue
			remove_child(loot)
			area.get_parent().add_child(loot)
		get_tree().queue_delete(self)
extends AudioStreamPlayer
class_name MusicTrack

export var default_volume = 0.0

func _ready():
	MusicMan.connect("bar", self, "_volume")

func _volume(n):
	var goal = volume(n)
	volume_db = goal

func volume(_n) -> float:
	return default_volume

func enemy_count(type: String) -> int:
	var out = 0
	for tank in get_tree().get_nodes_in_group("tank"):
		if tank.team > 0 && type == "" || tank.type == type:
			out += 1
	return out

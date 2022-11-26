extends MeshInstance

func _ready():
	MusicMan.connect("beat", self, "beat")

func beat(_n):
	$Tween.stop_all()
	scale = Vector3(1,1,1)
	$Tween.interpolate_property(self, "scale", Vector3(1, 1, 1), Vector3.ZERO, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()

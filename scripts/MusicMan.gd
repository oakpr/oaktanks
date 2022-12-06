extends Node

signal beat(n);
signal bar(n);

onready var reg = preload('res://scenes/MusicMixer.tscn').instance()

func _ready():
	reg.connect("beat", self, "beat")
	reg.connect("bar", self, "bar")
	# Add all song scenes
	var dir = Directory.new()
	dir.open("res://music");
	dir.list_dir_begin(true, true)
	var file_name = dir.get_next()
	while file_name != "":
		reg.add_child(load("res://music/"+file_name+"/"+file_name+".tscn").instance())
		file_name = dir.get_next()
	add_child(reg)

func play(song_name: String):
	while reg.get_parent() != self || reg.get_child_count() <= 2:
		yield(get_tree(), "idle_frame")
	if reg.playing:
		reg.init_song(song_name)
		reg.queue_bar_transition(song_name)
	else:
		reg.init_song(song_name)
		reg.call_deferred("play", song_name)

func beat(n: int):
	emit_signal("beat", n)

func bar(n: int):
	emit_signal("bar", n)

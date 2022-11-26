extends Node

var player: AudioStreamPlayer
var info: MusicRes
var last_beat = 0;

# true constants
const COMPENSATE_FRAMES = 2
const COMPENSATE_HZ = 60.0

signal beat;

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)

func play(song_name: String):
	var song = load("res://music/%s.ogg" % song_name);
	info = load("res://music/%s.tres" % song_name);
	player.stop()
	last_beat = 0
	player.stream = song
	player.play()

func _process(delta):
	if !player.playing:
		return
	var time = player.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency() + (1 / COMPENSATE_HZ) * COMPENSATE_FRAMES
	var beat = int(time * info.bpm / 60.0)
	if beat != last_beat:
		emit_signal("beat", beat)
		last_beat = beat
	var seconds = int(time)
	var seconds_total = int(player.stream.get_length())

func strsec(secs):
	var s = str(secs)
	if (secs < 10):
		s = "0" + s
	return s

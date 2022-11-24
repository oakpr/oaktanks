extends AudioStreamPlayer

# depends on the music track
const BPM = 116
const BARS = 4

# true constants
const COMPENSATE_FRAMES = 2
const COMPENSATE_HZ = 60.0

onready var MusicLabel: Label3D = $MusicLabel
var last_beat: int = 0
signal beat(n)


enum SyncSource {
	SYSTEM_CLOCK,
	SOUND_CLOCK,
}

var sync_source = SyncSource.SYSTEM_CLOCK

# Used by system clock.
var time_begin
var time_delay

func strsec(secs):
	var s = str(secs)
	if (secs < 10):
		s = "0" + s
	return s

func _process(_delta):
	if not playing:
		return
	var time = get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency() + (1 / COMPENSATE_HZ) * COMPENSATE_FRAMES
	var beat = int(time * BPM / 60.0)
	if beat != last_beat:
		emit_signal("beat", beat)
		last_beat = beat
	var seconds = int(time)
	var seconds_total = int(stream.get_length())
	$MusicLabel.text = str("BEAT: ", beat % BARS + 1, "/", BARS, " TIME: ", seconds / 60, ":", strsec(seconds % 60), " / ", seconds_total / 60, ":", strsec(seconds_total % 60))

func _ready():
	playing = true
	play()

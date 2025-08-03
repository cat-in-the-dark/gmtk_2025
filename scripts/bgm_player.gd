extends AudioStreamPlayer
class_name BgmPlayer

var playing_track: int = 0
var target_track: int = 0
var clip_count: int = 0;

func _ready() -> void:
	var s = stream as AudioStreamInteractive
	clip_count = s.clip_count


func _decide_track() -> int:
	return target_track;

func _process(delta: float) -> void:
	var next_track := _decide_track()
	if next_track != playing_track:
		playing_track = next_track
		var playback := get_stream_playback() as AudioStreamPlaybackInteractive
		playback.switch_to_clip(playing_track)


func on_room_note_collected(n_notes: int, n_collected_notes: int) -> void:
	print('_on_room_note_collected: ', [n_notes, n_collected_notes])
	n_collected_notes = min(n_collected_notes, n_notes)
	target_track = roundi(n_collected_notes * (clip_count - 1.0) / n_notes)
	print('target_track:', target_track )
	if (n_collected_notes > 0):
		$JumpPlayer.play()
	pass # Replace with function body.

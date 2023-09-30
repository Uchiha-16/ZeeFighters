extends AudioStreamPlayer2D

var audio

func ready():
	audio = preload("res://Music/dragon-ball-music_dbz-ost-saga-saiyajin.wav")
	set_stream(audio)
	set_process(true)

func _process(delta):
	if not is_playing():
		play()

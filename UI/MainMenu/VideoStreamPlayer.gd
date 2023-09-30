extends VideoStreamPlayer

var video

func _ready():
	video = preload("res://UI/MainMenu/Dragon-Ball-Z-goku-Background-video-loop-neon-fast-_.ogv")
	set_stream(video)
	set_process(true)

func _process(delta):
	if not is_playing():
		play()

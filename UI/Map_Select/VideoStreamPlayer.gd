extends VideoStreamPlayer

var video

func _ready():
	video = preload("res://UI/Map_Select/vegeta-ultra-ego.3840x2160.ogv")
	set_stream(video)
	set_process(true)

func _process(delta):
	if not is_playing():
		play()

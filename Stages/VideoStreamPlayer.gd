extends VideoStreamPlayer

var video

func _ready():
	video = preload("res://Stages/Stage Assets/kame-house-dragon-ball-z-moewalls-com.ogv")
	set_stream(video)
	set_process(true)

func _process(delta):
	if not is_playing():
		play()

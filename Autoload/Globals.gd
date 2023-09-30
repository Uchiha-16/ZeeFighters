extends Node

var hit:bool = false

func hitstun(mod,duration):
		Engine.time_scale = mod/100
		print(str(mod))
		await get_tree().create_timer(duration*Engine.time_scale).timeout
		Engine.time_scale = 1

#func _process(delta):
#	if Input.is_action_just_pressed("ui_home"):
#		if Engine.time_scale < 1:
#			Engine.time_scale = 1
#		else:
#			Engine.time_scale = 0.1

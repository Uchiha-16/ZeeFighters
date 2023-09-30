extends Control

# Define onready variables for UI elements
@onready var menu = $Menu
@onready var options = $Options
@onready var video = $Video
@onready var audio = $Audio
@onready var gif = $VideoStreamPlayer

# Handle input events
func _process(delta):
	# Toggle visibility and pause the game when the cancel button is pressed
	if Input.is_action_just_pressed("ui_cancel"):
		toggle()

# Toggle visibility and pause the game
func toggle():
	visible = !visible
	get_tree().paused = visible

# Change scene when play button is pressed
func _on_play_pressed():
	toggle()
	get_tree().change_scene_to_file("res://UI/Map_Select/level_select_screen.tscn")

# Show and hide menu and options
func _on_option_pressed():
	show_and_hide(options, menu)

# Helper function to show and hide UI elements
func show_and_hide(first, second):
	first.show()
	second.hide()

# Go back from options to main menu
func _on_back_from_options_pressed():
	show_and_hide(menu, options)
	
# Print a message and quit the game when the exit button is pressed
func _on_exit_pressed():
	print("Till next time!")
	get_tree().quit()

# Show audio options and hide options when audio button is pressed
func _on_audio_pressed():
	show_and_hide(audio, options)

# Show video options and hide options when video button is pressed
func _on_video_pressed():
	show_and_hide(video, options)

# Go back from video options to main options
func _on_back_from_video_pressed():
	show_and_hide(options, video)

# Go back from audio options to main options
func _on_back_from_audio_pressed():
	show_and_hide(options, audio)

# Handle fullscreen toggle
func _on_fullscreen_toggled(button_pressed):
	if button_pressed == true:
		# Set the display mode to fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		# Set the display mode to windowed
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# Handle borderless toggle
func _on_borderless_toggled(button_pressed):
	if button_pressed == true:
		# Set the display mode to exclusive fullscreen (borderless)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		# Set the display mode to windowed
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

# Handle V-Sync toggle
func _on_v_sync_toggled(button_pressed):
	if button_pressed == true:
		# Enable V-Sync
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		# Disable V-Sync
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

# Handle master volume slider value change
func _on_master_value_changed(value):
	# Adjust the master volume
	volume(0, value)

# Adjust volume for a specific audio bus
func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)

# Handle music volume slider value change
func _on_music_value_changed(value):
	# Adjust the music volume
	volume(1, value)

# Handle sound effects volume slider value change
func _on_sound_fx_value_changed(value):
	# Adjust the sound effects volume
	volume(2, value)



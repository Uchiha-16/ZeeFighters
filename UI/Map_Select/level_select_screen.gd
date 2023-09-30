extends Control

const map_btn = preload("res://UI/Map_Select/lvl_btn.tscn")

@export_dir var dir_path

@onready var grid = $MarginContainer/VBoxContainer/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_maps(dir_path)


func get_maps(path):
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				print(file_name)
				create_level_btn('%s/%s' % [dir.get_current_dir(), file_name], file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
		
		
func create_level_btn(map_path, map_name):
	var btn = map_btn.instantiate()
	btn.text = map_name.trim_suffix('.tscn').replace("_", " ")
	btn.map_path = map_path
	grid.add_child(btn)



func _on_back_pressed():
	get_tree().change_scene_to_file("res://UI/MainMenu/main_menu.tscn")

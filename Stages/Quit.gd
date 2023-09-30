extends Button

@export var SceneToLoad : PackedScene


func _on_pressed():
		get_tree().change_scene_to_packed(SceneToLoad)
		
func _on_Area2D_area_entered(area):
	emit_signal("focus_entered")
	
func _on_Area2D_area_exited(area):
	emit_signal("focus_exited")

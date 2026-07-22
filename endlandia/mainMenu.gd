extends Control

func _on_start():
	#check for save files
	var current_level_path = "res://scenes/world_1.tscn"
	# load scene
	#
	get_tree().change_scene_to_file(current_level_path)

extends Area3D

func _on_body_entered(body:Node3D):
	get_tree().change_scene_to_file("res://Scenes/Menus/Win/WinScreen.tscn")

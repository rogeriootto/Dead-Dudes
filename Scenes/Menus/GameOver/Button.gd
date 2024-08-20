extends Button

func _on_button_down():
	HUDmanager.Player1Health = 3
	HUDmanager.Player2Health = 3
	HUDmanager.Player1InventorySize = 4
	HUDmanager.Player2InventorySize = 4
	HUDmanager.alreadyGameOver = false
	var loadingScreen = load("res://Scenes/Menus/Loading/Loading.tscn")
	GlobalVariables.sceneToLoad = "res://Scenes/Levels/level_1.tscn"
	get_tree().change_scene_to_packed(loadingScreen)

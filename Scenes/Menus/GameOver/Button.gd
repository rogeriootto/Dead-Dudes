extends Button

func _on_button_down():
	HUDmanager.Player1Health = 3
	HUDmanager.Player2Health = 3
	HUDmanager.Player1InventorySize = 4
	HUDmanager.Player2InventorySize = 4
	HUDmanager.alreadyGameOver = false
	GlobalVariables.sceneToLoad = "res://Scenes/Levels/level_1.tscn"
	LoadingScreen.visible = true
	LoadingScreen.onLoadingReady()
	await LoadingScreen.onLoadingFinished
	
	

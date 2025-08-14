extends Button

func _on_button_down():
	get_tree().paused = false
	PauseMenu.visible = false
	GlobalVariables.player1Position = Vector3(-500,-500,-500)
	GlobalVariables.player2Position = Vector3(-500,-500,-500)
	HUDmanager.alreadyGameOver = false
	GlobalVariables.sceneToLoad = GlobalVariables.lastSceneLoaded
	LoadingScreen.visible = true
	LoadingScreen.onLoadingReady()
	await LoadingScreen.onLoadingFinished
	

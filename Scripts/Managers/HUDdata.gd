extends Node

var Player1Health: int = 3
var Player2Health: int = 3
var Player1InventorySize: int = 4
var Player2InventorySize: int = 4
var alreadyGameOver = false


func checkIfGameOver():
	if (Player1Health <= 0 or Player2Health <= 0) and !alreadyGameOver:
		alreadyGameOver = true
		TransitionToDeathScreen.transition()
		await TransitionToDeathScreen.onTransitionToDeathFinished
		get_tree().change_scene_to_file("res://Scenes/Menus/GameOver/GameOver.tscn")

func _process(delta):
	if alreadyGameOver:
		return
	checkIfGameOver()

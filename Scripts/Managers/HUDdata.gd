extends Node

var Player1Health: int = 3
var Player2Health: int = 3

func checkIfGameOver():
    if Player1Health <= 0 or Player2Health <= 0:
        get_tree().change_scene_to_file("res://Scenes/Menus/GameOver/GameOver.tscn")

func _process(delta):
    checkIfGameOver()
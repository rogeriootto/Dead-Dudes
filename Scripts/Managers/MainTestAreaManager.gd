extends Node3D

var player1Preload := preload("res://Scenes/Objects/Jack.tscn")
var player2Preload := preload("res://Scenes/Objects/John.tscn")

var player1: CharacterBody3D
var player2: CharacterBody3D

@export var player1SpawnPoint: Vector3
@export var player2SpawnPoint: Vector3

@export var inventorySize: int = 0

func _ready():
	GlobalVariables.lastSceneLoaded = get_tree().current_scene.scene_file_path
	player1 = player1Preload.instantiate()
	if player1:
		add_child(player1)
		player1.position = player1SpawnPoint
		player1.playerNumber = 'p1'
		player1.playerInventory = inventorySize
		player1.playerHP = 3
		HUDmanager.Player1InventorySize = inventorySize
		HUDmanager.Player1Health = 3
		player1.add_to_group('p1')
		player1.add_to_group('players')
		get_node('Camera3D').player1 = player1
	
	player2 = player2Preload.instantiate()
	if player2:
		add_child(player2)
		player2.position = player2SpawnPoint
		player2.playerNumber = 'p2'
		player2.playerInventory = inventorySize
		player2.playerHP = 3
		HUDmanager.Player2InventorySize = inventorySize
		HUDmanager.Player2Health = 3
		player2.add_to_group('p2')
		player2.add_to_group('players')
		get_node('Camera3D').player2 = player2

func _process(delta):
	pass

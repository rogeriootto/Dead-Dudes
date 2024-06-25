extends Node3D

var player1Preload := preload("res://Scenes/Objects/Jack.tscn")
var player2Preload := preload("res://Scenes/Objects/Jack.tscn")

var player1: CharacterBody3D
var player2: CharacterBody3D

@export var player1SpawnPoint: Vector3
@export var player2SpawnPoint: Vector3



func _ready():
	var signalManager = get_node('SignalManager')

	player1 = player1Preload.instantiate()
	if player1:
		add_child(player1)
		player1.position = player1SpawnPoint
		player1.playerNumber = 'p1'
		get_node('Camera3D').player1 = player1
		player1.signalManager = signalManager
	
	player2 = player2Preload.instantiate()
	if player2:
		add_child(player2)
		player2.position = player2SpawnPoint
		player2.playerNumber = 'p2'
		get_node('Camera3D').player2 = player2
		player2.signalManager = signalManager
		

func _process(delta):
	pass

extends Node

@export var p1ShouldSpawn: bool = true
@export var p2ShouldSpawn: bool = true

var player1Position: Vector3
var player2Position: Vector3
var astarNode: Object

var sceneToLoad: String
var lastSceneLoaded: String

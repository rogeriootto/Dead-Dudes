extends CharacterBody3D

@export var comprimento: int
@export var largura: int
@export var altura: int
@export var type: String
func interact(playerNumber: String):
	SignalManager.emitMoveObstacleRequest(self, true, playerNumber)

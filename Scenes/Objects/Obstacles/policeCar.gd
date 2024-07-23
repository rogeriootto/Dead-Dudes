extends CharacterBody3D

@export var comprimento: int
@export var largura: int
@export var altura: int
@export var type: String
func interact(playerNumber: String):
	print('player number: ', playerNumber)
	SignalManager.emitMoveObstacleRequest(self, true, playerNumber)

func _ready():
	self.position.x = snapped(position.x, AstarManager.grid_step)
	self.position.z = snapped(position.z, AstarManager.grid_step) - AstarManager.grid_step/2
	print('teste')

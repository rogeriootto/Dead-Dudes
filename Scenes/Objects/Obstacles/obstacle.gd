extends StaticBody3D

@export var comprimento: int
@export var largura: int
@export var altura: int
@export var type: String
func interact():
	SignalManager.emitObstacleRemoveRequest(self)

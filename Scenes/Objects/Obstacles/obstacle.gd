extends StaticBody3D

func interact():
	SignalManager.emitObstacleRemoveRequest(self)

extends Node3D

signal obstacleSpawnRequest(obstacleName: String, obstaclePosition: Vector3)
signal showObstacleRequest(obstacleName: String, obstaclePosition: Vector3)
signal obstacleRemoveRequest(obstaclePosition: Vector3)
signal interactRequest()
signal moveObstacleRequest(obstacle: Object)
signal interactableNameRequest(name: String)

func registerListner(signalName: String, target: Object, method: String): 
	if not has_signal(signalName):
		return
	var callable = Callable(target, method)
	if not is_connected(signalName, callable):
		connect(signalName, callable)

func unregisterListner(signalName: String, target: Object, method: String):
	var callable = Callable(target, method)
	if is_connected(signalName, callable):
		disconnect(signalName, callable)

func emitObstacleSpawnRequest(obstacleName: String, obstaclePosition: Vector3):
	emit_signal("obstacleSpawnRequest", obstacleName, obstaclePosition)

func emitShowObstacle(showObjectFlag: bool, obstacleName: String, obstaclePosition: Vector3):
	emit_signal("showObstacleRequest", showObjectFlag, obstacleName, obstaclePosition)

func emitObstacleRemoveRequest(obstacle: StaticBody3D):
	emit_signal("obstacleRemoveRequest",obstacle)

func emitMoveObstacleRequest(obstacle: Object, should_reconect_points: bool, playerNumber: String = ''):
	emit_signal("moveObstacleRequest",obstacle, should_reconect_points, playerNumber)

func emitInteractRequest(playerNumber: String = ''):
	print('emitInteractRequest signal manager')
	emit_signal("interactRequest", playerNumber)

func emitInteractableName(name: String):
	emit_signal("interactableNameRequest", name)

#func emitDisconnectAreaRequest(obstacle: Object, comprimento: int, largura: int, altura: int):
#	emit_signal("disconnectAreaRequest", obstacle, comprimento, largura, altura)

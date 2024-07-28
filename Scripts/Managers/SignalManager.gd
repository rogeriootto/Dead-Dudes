extends Node3D

signal obstacleSpawnRequest(obstacleName: String, obstaclePosition: Vector3)
signal showObstacleRequest(obstacleName: String, obstaclePosition: Vector3)
signal obstacleRemoveRequest(obstaclePosition: Vector3)
signal interactRequest(playerNumber: String)
signal interactRequestP1()
signal interactRequestP2()
signal moveObstacleRequest(obstacle: Object)
signal interactableNameRequest(name: String)

func registerListner(signalName: String, target: Object, method: String): 
	if not has_signal(signalName):
		return
	var callable = Callable(target, method)
	if not is_connected(signalName, callable):
		connect(signalName, callable)
		print('connected signal: ' + signalName + ' to ' + target.name)

func unregisterListner(signalName: String, target: Object, method: String):
	var callable = Callable(target, method)
	if is_connected(signalName, callable):
		disconnect(signalName, callable)
		print('disconnected signal: ', signalName)

func emitObstacleSpawnRequest(obstacleName: String, obstaclePosition: Vector3):
	emit_signal("obstacleSpawnRequest", obstacleName, obstaclePosition)

func emitShowObstacle(showObjectFlag: bool, obstacleName: String, obstaclePosition: Vector3):
	emit_signal("showObstacleRequest", showObjectFlag, obstacleName, obstaclePosition)

func emitObstacleRemoveRequest(obstacle: StaticBody3D):
	emit_signal("obstacleRemoveRequest",obstacle)

func emitMoveObstacleRequest(obstacle: Object, should_reconect_points: bool, playerNumber: String = ''):
	emit_signal("moveObstacleRequest",obstacle, should_reconect_points, playerNumber)

func emitInteractRequest(playerNumber: String = ''):
	print('emitInteractRequest')
	print('playerNumber: ', playerNumber)
	emit_signal("interactRequest", playerNumber)

func emitInteractRequestP1():
	emit_signal("interactRequestP1", 'p1')

func emitInteractRequestP2():
	emit_signal("interactRequestP2", 'p2')

func emitInteractableName(obstacleName: String):
	emit_signal("interactableNameRequest", obstacleName)

#func emitDisconnectAreaRequest(obstacle: Object, comprimento: int, largura: int, altura: int):
#	emit_signal("disconnectAreaRequest", obstacle, comprimento, largura, altura)

extends Node3D

signal obstacleSpawnRequest(obstacleName: String, obstaclePosition: Vector3)
signal showObstacleRequest(obstacleName: String, obstaclePosition: Vector3)
signal obstacleRemoveRequest(obstaclePosition: Vector3)
signal interactRequest()

func registerListner(signalName: String, target: Object, method: String): 
	if not has_signal(signalName):
		print("SignalManager: Sinal não definido - ", signalName)
		return
	var callable = Callable(target, method)
	connect(signalName, callable)
	# print("SignalManager: Sinal conectado - ", signalName)

func unregisterListner(signalName: String, target: Object, method: String):
	var callable = Callable(target, method)
	print('chegou aqui')
	if is_connected(signalName, callable):
		disconnect(signalName, callable)
		print("SignalManager: Sinal desconectado - ", signalName)

func emitObstacleSpawnRequest(obstacleName: String, obstaclePosition: Vector3):
	emit_signal("obstacleSpawnRequest", obstacleName, obstaclePosition)

func emitShowObstacle(showObjectFlag: bool, obstacleName: String, obstaclePosition: Vector3):
	emit_signal("showObstacleRequest", showObjectFlag, obstacleName, obstaclePosition)

func emitObstacleRemoveRequest(obstacle: StaticBody3D):
	emit_signal("obstacleRemoveRequest",obstacle)

func emitInteractRequest():
	emit_signal("interactRequest")
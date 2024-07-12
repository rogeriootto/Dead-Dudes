extends PlayerGrounded
class_name PlayerBuilding

func Enter():
#	print('entrou em building mode')
	animControl.play("Tatsu")
	pass
	
func Exit():
#	print('saiu do building mode')
	SignalManager.emitShowObstacle(false ,'box1x1', getSpawnPosition(2))
	pass
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	playerMovement()
	
	if Input.is_action_just_pressed("buildingPut_" + player.getPlayerNumber()):
		dropObstacle('box1x1', getSpawnPosition(3))
	
	if Input.is_action_just_released("buildingMode_" + player.getPlayerNumber()):
		Transitioned.emit(self, 'PlayerIdle')

	SignalManager.emitShowObstacle(true ,'box1x1', getSpawnPosition(3))
	

func getSpawnPosition(distance: int):
	return player.position - player.basis.z.normalized() * -distance

extends PlayerGrounded
class_name PlayerBuilding

func Enter():
	animControl.play("Tatsu")
	interaction_area.can_interact = false
	pass
	
func Exit():
	SignalManager.emitShowObstacle(false ,'box1x1', getSpawnPosition(3))
	interaction_area.can_interact = true
	pass
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	playerMovement()
	
	if Input.is_action_just_pressed("buildingPut_" + player.getPlayerNumber()):
		SignalManager.emitObstacleSpawnRequest("box1x1", getSpawnPosition(3), player)
	
	if Input.is_action_just_released("buildingMode_" + player.getPlayerNumber()):
		Transitioned.emit(self, 'PlayerIdle')

	SignalManager.emitShowObstacle(true ,'box1x1', getSpawnPosition(3))

	velocityTest = abs(player.velocity.x) + abs(player.velocity.z)

	if velocityTest == 0:
		animControl.play("Idle")
	elif velocityTest > 0 && velocityTest <= 6:
		animControl.play("Walk")
	elif velocityTest > 6:
		animControl.play("Running")
	

func getSpawnPosition(distance: int):
	return player.position - player.basis.z.normalized() * -distance

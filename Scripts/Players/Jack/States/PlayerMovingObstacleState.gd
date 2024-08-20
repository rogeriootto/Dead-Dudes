extends PlayerGrounded
class_name PlayerMovingObstacleState

func Enter():
	animControl.play("Pushing")
	player.axis_lock_angular_y = true
	pass
	
func Exit():
	player.axis_lock_angular_y = false
	pass
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	playerMovement(-3)
	
	if Input.is_action_pressed("interact_" + player.getPlayerNumber()):
		if player.getPlayerNumber() == 'p1':
			SignalManager.emitInteractRequestP1()
		else:
			SignalManager.emitInteractRequestP2()
	
	if Input.is_action_just_released("interact_" + player.getPlayerNumber()):
		Transitioned.emit(self, 'PlayerIdle')
	

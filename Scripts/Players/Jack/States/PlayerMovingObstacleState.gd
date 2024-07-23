extends PlayerGrounded
class_name PlayerMovingObstacleState

func Enter():
	animControl.play("Tatsu")
	pass
	
func Exit():
	pass
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	playerMovement(-5.0)
	
	if Input.is_action_pressed("interact"):
		SignalManager.emitInteractRequest(player.getPlayerNumber())
	
	if Input.is_action_just_released("interact"):
		Transitioned.emit(self, 'PlayerIdle')

	

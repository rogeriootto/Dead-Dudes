extends PlayerGrounded
class_name PlayerIdle

func Enter():
	animControl.play("Idle")
	pass
	
func Exit():
	pass
	
func Update(delta: float):
	pass
	
	
func Physics_Update(delta: float):
	playerMovement()
	velocityTest = abs(player.velocity.x) + abs(player.velocity.z)
	if velocityTest > 0:
		Transitioned.emit(self, 'PlayerWalking')
	pass

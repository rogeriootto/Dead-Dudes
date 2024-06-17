extends PlayerGrounded
class_name PlayerWalking

func Enter():
	animControl.play("Walk")
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	playerMovement()
	buttonsCheck()
	velocityTest = abs(player.velocity.x) + abs(player.velocity.z)
	if velocityTest == 0:
		Transitioned.emit(self, 'PlayerIdle')
	if velocityTest > 6:
		Transitioned.emit(self, 'PlayerRun')


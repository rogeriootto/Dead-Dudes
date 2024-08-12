extends PlayerGrounded
class_name PlayerWalking

func Enter():
	animControl.play("Walk")
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	playerMovement()
	buttonsCheck()
	gravityPhysics(delta, false)
	velocityTest = abs(player.velocity.x) + abs(player.velocity.z)
	if velocityTest == 0:
		Transitioned.emit(self, 'PlayerIdle')
	if velocityTest > 2:
		Transitioned.emit(self, 'PlayerRun')


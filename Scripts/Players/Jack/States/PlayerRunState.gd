extends PlayerGrounded
class_name PlayerRun

func Enter():
	animControl.play("Running")
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	playerMovement()
	velocityTest = abs(player.velocity.x) + abs(player.velocity.z)
	if velocityTest == 0:
		Transitioned.emit(self, 'PlayerIdle')
	if velocityTest < 6:
		Transitioned.emit(self, 'PlayerWalking')
	
	pass

func Exit():
	pass

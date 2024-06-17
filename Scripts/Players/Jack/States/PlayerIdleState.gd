extends PlayerGrounded
class_name PlayerIdle

var time = 0
func Enter():
	animControl.play("Idle")
	pass
	
func Exit():
	time = 0
	pass
	
func Update(delta: float):
	time += delta
	if time > 5:
		animControl.play("GangnamStyle")
	pass
	
func Physics_Update(delta: float):
	playerMovement()
	buttonsCheck()
		
	velocityTest = abs(player.velocity.x) + abs(player.velocity.z)
	if velocityTest > 0:
		Transitioned.emit(self, 'PlayerWalking')
		
	pass

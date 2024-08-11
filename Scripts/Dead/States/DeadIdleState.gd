extends DeadGrounded
class_name DeadIdle

var time = 0
func Enter():
	animControl.play("Idle")
	pass
	
func Exit():
	time = 0
	pass
	
func Physics_Update(delta: float):
	deadMovement(delta)
	if time > 5:
		animControl.play("Scream")
		time = 0

	if (abs(dead.velocity.x) + abs(dead.velocity.z)) > 0:
		Transitioned.emit(self, 'DeadWalking')
	
	time += delta
		
	pass

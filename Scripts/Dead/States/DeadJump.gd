extends DeadGrounded
class_name DeadJump

var jumping: bool

func Enter():
	animControl.play("Jump")
	jumping = true
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	deadMovement(delta)
	gravityPhysics(delta, jumping)
	if jumping:
		jumping = false

	if dead.is_on_floor():
		Transitioned.emit(self, 'DeadIdleState')
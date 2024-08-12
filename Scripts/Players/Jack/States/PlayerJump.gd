extends PlayerGrounded
class_name PlayerJump

var jumping: bool

func Enter():
	animControl.play("Flip")
	jumping = true
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	playerMovement(-3)
	gravityPhysics(delta, jumping)
	if jumping:
		jumping = false

	if player.is_on_floor():
		Transitioned.emit(self, 'PlayerIdle')
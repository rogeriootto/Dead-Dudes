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
		animControl.play("Idle2")
	pass
	
func Physics_Update(delta: float):
	playerMovement()
	buttonsCheck()
	gravityPhysics(delta, false)
		
	velocityTest = abs(player.velocity.x) + abs(player.velocity.z)
	if velocityTest > 0:
		Transitioned.emit(self, 'PlayerWalking')
		
	pass


func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "Idle2":
		animControl.play("Idle")
		time = 0

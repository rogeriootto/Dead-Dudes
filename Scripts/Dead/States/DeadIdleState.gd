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
	gravityPhysics(delta, false)
	check_if_player_is_close_to_attack()
	if time > 5:
		animControl.play("Scream")
	
	if (abs(dead.velocity.x) + abs(dead.velocity.z)) > 0:
		Transitioned.emit(self, 'DeadWalking')

	time += delta

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "Scream":
		animControl.play("Idle")
		time = 0

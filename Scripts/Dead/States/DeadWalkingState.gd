extends DeadGrounded
class_name DeadWalking

func Enter():
	if RandomNumberGenerator.new().randi_range(0, 1) == 0:
		animControl.play("Walking", -1, 5)
	else:
		animControl.play("Walking2", -1, 5)
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	deadMovement(delta)
	gravityPhysics(delta, false)
	check_if_player_is_close_to_attack()
	get_distance_traveled()

	if (abs(dead.velocity.x) + abs(dead.velocity.z)) == 0:
		Transitioned.emit(self, 'DeadIdleState')

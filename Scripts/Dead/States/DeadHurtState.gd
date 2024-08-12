extends DeadGrounded
class_name DeadHurt

func Enter():
	animControl.play("GetHit", -1, 3)
	print("Dead Hurt State")
	pass

func Exit():
	dead.tookHit = false
	pass
	
func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "GetHit":
		if dead.isDead:
			Transitioned.emit(self, 'DeadDeadState')
		else:
			Transitioned.emit(self, 'DeadIdleState')

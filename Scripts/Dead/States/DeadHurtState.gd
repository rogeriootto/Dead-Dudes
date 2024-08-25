extends DeadGrounded
class_name DeadHurt

@export var sangueVFX: Node3D

func Enter():
	animControl.play("GetHit", -1, 3)
	sangueVFX.startVFX()
	pass

func Exit():
	dead.tookHit = false
	sangueVFX.stopVFX()
	pass

func Physics_Update(delta: float):
	if dead.isDead:
		Transitioned.emit(self, 'DeadDeadState')
	dead.move_and_slide()

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "GetHit":
		if dead.isDead:
			Transitioned.emit(self, 'DeadDeadState')
		else:
			Transitioned.emit(self, 'DeadIdleState')

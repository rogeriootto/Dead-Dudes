extends DeadGrounded
class_name DeadAttack

@export var attackHitbox: Area3D

func Enter():
	animControl.play("Attack", -1, 2)
	attackHitbox.monitoring = false
	pass
	
func Exit():
	attackHitbox.monitoring = false
	pass
	
func Physics_Update(delta: float):
	if animControl.current_animation_position > 1.5:
		attackHitbox.monitoring = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack":
		Transitioned.emit(self, 'DeadIdleState')

func _on_attack_body_entered(body:Node3D):
	if body.is_in_group("players") && animControl.current_animation_position > 1:
		body.dealDamage(1)
		var look_direction = (body.global_position - dead.global_position)
		body.velocity = look_direction * 50
		body.move_and_slide()


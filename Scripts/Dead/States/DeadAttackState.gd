extends DeadGrounded
class_name DeadAttack

@export var attackHitbox: Area3D
var alreadyAttacked = false

func Enter():
	animControl.play("Attack", -1, 2)
	attackHitbox.monitoring = false
	alreadyAttacked = false
	pass
	
func Exit():
	attackHitbox.monitoring = false
	pass
	
func Physics_Update(delta: float):
	checkIfTookHit()
	if animControl.current_animation_position > 1.5:
		attackHitbox.monitoring = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack":
		Transitioned.emit(self, 'DeadIdleState')

func _on_attack_body_entered(body:Node3D):
	if body.is_in_group("players") && animControl.current_animation_position > 1 && !alreadyAttacked:
		body.dealDamage(1)
		alreadyAttacked = true
		var look_direction = (body.global_position - dead.global_position)
		body.velocity.x = look_direction.x * 50
		body.velocity.z = look_direction.z * 50
		body.move_and_slide()

extends PlayerGrounded
class_name NormalAttack

var attackAnim : int
@export var attackArea: Area3D

func Enter():
	attackAnim = RandomNumberGenerator.new().randi_range(0, 1)
	if attackAnim == 0:
		animControl.play("Punch")
	else:
		animControl.play("Kick")
	attackArea.monitoring = true
	
func Exit():
	attackArea.monitoring = false
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	pass

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "Punch" or anim_name == "Kick":
		Transitioned.emit(self, 'PlayerIdle')


func _on_kick_punch_area_body_entered(body:Node3D):
	body.dealDamage(1)
	var look_direction = (body.global_position - player.global_position)
	body.velocity = look_direction * 25
	body.move_and_slide()

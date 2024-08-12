extends PlayerGrounded
class_name JohnAttack

@export var tacoBox: Area3D

func Enter():
	animControl.play("Taco")
	tacoBox.monitoring = true
	pass
	
func Exit():
	tacoBox.monitoring = false
	pass
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Taco":
		Transitioned.emit(self, 'PlayerIdle')

func _on_taco_box_body_entered(body):
	body.dealDamage(2)
	var look_direction = (body.global_position - player.global_position)
	body.velocity = look_direction * 50
	body.move_and_slide()

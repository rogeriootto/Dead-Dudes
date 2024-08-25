extends PlayerGrounded
class_name JackSpecialAttack

@onready var bullet = preload("res://Scenes/Objects/bullet.tscn")
var bulletInstance

func Enter():
	animControl.play("Gun")
	bulletInstance = bullet.instantiate()
	add_child(bulletInstance)
	bulletInstance.position = Vector3(player.position.x, player.position.y + 1, player.position.z)
	bulletInstance.apply_central_impulse(player.global_transform.basis.z * 50)
	
func Exit():
	pass
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	pass

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "Gun":
		Transitioned.emit(self, 'PlayerIdle')

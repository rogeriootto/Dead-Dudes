extends PlayerGrounded
class_name JackSpecialAttack

@onready var bullet = preload("res://Scenes/Objects/bullet.tscn")
@export var bulletVFX: Node3D

var bulletInstance

func Enter():
	animControl.play("Gun")
	bulletInstance = bullet.instantiate()
	add_child(bulletInstance)
	bulletInstance.position = Vector3(player.position.x, player.position.y + 1, player.position.z)
	bulletInstance.apply_central_impulse(player.global_transform.basis.z * 50)
	bulletVFX.startTiro()
	
func Exit():
	pass
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	if animControl.current_animation_position > 0.2:
		bulletVFX.endTiro()

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "Gun":
		bulletVFX.turnOffTiro()
		Transitioned.emit(self, 'PlayerIdle')

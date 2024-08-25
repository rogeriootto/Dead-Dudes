extends PlayerState
class_name PlayerPickingUp
@export var animControl : AnimationPlayer

func Enter():
	animControl.play("Pickup", -1, 2)
	pass
	
func Update(delta: float):
	if animControl.current_animation_position > 1.2:
		Transitioned.emit(self, 'PlayerIdle')

func _on_animation_player_animation_finished(anim_name:StringName):
	if anim_name == "Pickup":
		Transitioned.emit(self, 'PlayerIdle')
	pass

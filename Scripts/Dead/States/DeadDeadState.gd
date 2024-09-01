extends DeadGrounded
class_name DeadDead

@export var collisionShape: CollisionShape3D

@export var sangueVFX: Node3D

func Enter():
	animControl.play("Death", -1, 3)
	collisionShape.disabled = true
	raycast.enabled = false
	sangueVFX.startVFX()

func Exit():
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Death":
		sangueVFX.stopVFX()

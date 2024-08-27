extends DeadGrounded
class_name DeadFallen

@export var fall_collision: CollisionShape3D
@export var dead_collision: CollisionShape3D

func Enter():
	if dead.position:
		dead.position = GlobalVariables.astarNode.dead_should_fall(dead.global_transform.origin)
		animControl.play("Crouching", -1, 3)
		dead_collision.disabled = true
		fall_collision.disabled = false
		for deads in $"../../../Area3D".get_overlapping_bodies():
			deads.should_update_path = true
			deads.count_fallen = 0.0
		pass

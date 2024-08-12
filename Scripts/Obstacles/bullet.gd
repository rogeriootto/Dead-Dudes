extends RigidBody3D

func _on_area_3d_body_entered(body:Node3D):
	print("Bullet hit " + body.name)
	if body.has_method("dealDamage"):
		body.dealDamage(2)
		var look_direction = (body.global_position - self.global_position)
		body.velocity = look_direction * 25
		body.move_and_slide()
		queue_free()
	else:
		queue_free()

extends RigidBody3D

func _on_area_3d_body_entered(body:Node3D):
	print("Bullet hit " + body.name)
	if body.has_method("dealDamage"):
		body.dealDamage(2)
		queue_free()
	else:
		queue_free()

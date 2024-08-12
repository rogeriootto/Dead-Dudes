extends DeadGrounded
class_name DeadDead

@export var collisionShape: CollisionShape3D

func Enter():
	animControl.play("Death", -1, 3)
	collisionShape.disabled = true
	raycast.enabled = false

func Exit():
	pass
	

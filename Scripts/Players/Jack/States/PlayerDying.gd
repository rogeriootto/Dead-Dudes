extends PlayerState
class_name PlayerDying

@export var collisionShape: CollisionShape3D
@export var animationPlayer: AnimationPlayer

func Enter():
	animationPlayer.play("Dying")
	collisionShape.disabled = true

func Exit():
	pass
	

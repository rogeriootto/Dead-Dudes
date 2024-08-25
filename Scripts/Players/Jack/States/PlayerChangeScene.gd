extends PlayerState
class_name PlayerChangeScene

var winMovDirection
var speed = 15
@export var player: CharacterBody3D
@export var animControl : AnimationPlayer

func Enter():
	animControl.play("Running")

func Physics_Update(delta):
	winMovDirection = Vector3(0,0,-1)
	player.velocity = winMovDirection * speed
	var look_direction = Vector2(player.velocity.z, player.velocity.x)
	player.rotation.y = look_direction.angle()
	player.move_and_slide()

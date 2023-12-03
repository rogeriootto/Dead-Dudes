extends CharacterBody2D


const SPEED = 300.0
@export var side = 'p1'

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(_delta):
	
	var direction
	if(side == 'p1'):
		direction = Input.get_axis("p1-cima", "p1-baixo")
	else:
		direction = Input.get_axis("p2-cima", "p2-baixo")
		
	if direction:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	


func _on_area_2d_body_entered(body):
	body.direction.x *= -1

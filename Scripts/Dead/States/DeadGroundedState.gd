extends PlayerState
class_name DeadGrounded

@onready var raycast = get_parent().get_parent().get_parent().get_node("RayCast3D")
@export var dead: CharacterBody3D
@export var animControl: AnimationPlayer

var path := []
var current_target := Vector3.INF
var speed := RandomNumberGenerator.new().randi_range(2, 3)
var count = 0 
var should_update_path:bool = true
var should_activate_zombie:bool = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func Enter():
	pass
	
func Update(delta: float):
	pass
		
func Physics_Update(delta: float):
	pass

func Exit():
	pass

func check_if_player_is_close_to_attack():
	var dist_to_p1 = dead.global_transform.origin.distance_to(AstarManager.player1Position)
	var dist_to_p2 = dead.global_transform.origin.distance_to(AstarManager.player2Position)
	if dist_to_p1 < 2 or dist_to_p2 < 2:
		Transitioned.emit(self, 'DeadAttackState')

func checkIfIsDeadDead():
	if dead.isDead:
		Transitioned.emit(self, 'DeadDeadState')

func checkIfTookHit():
	if dead.tookHit:
		Transitioned.emit(self, 'DeadHurtState')

func gravityPhysics(delta: float, jumping: bool):
	var jumpVelocity = 4
	if not dead.is_on_floor():
		dead.velocity.y -= gravity * delta
	
	if jumping and dead.is_on_floor():
		dead.velocity.y = jumpVelocity

	dead.move_and_slide()

func deadMovement(delta: float):

	checkIfTookHit()
	checkIfIsDeadDead()
	
	var dist_to_p1 = dead.global_transform.origin.distance_to(AstarManager.player1Position)
	var dist_to_p2 = dead.global_transform.origin.distance_to(AstarManager.player2Position)
			
	if (should_activate_zombie == false && (dist_to_p1 > 40 && dist_to_p2 > 40)):
		return
	else:
		should_activate_zombie = true

	var seeking_p1 = dist_to_p1 < dist_to_p2
	#TODO ver pq o raycast não ta batendo em algumas merda exemplo, banco

	if seeking_p1:
		raycast.target_position = (Vector3(AstarManager.player1Position.x,AstarManager.player1Position.y+1,AstarManager.player1Position.z) - dead.position)
	else:
		raycast.target_position = (Vector3(AstarManager.player2Position.x,AstarManager.player2Position.y+1,AstarManager.player2Position.z) - dead.position)
	
	if raycast.get_collider() != null:
		var collision_result = raycast.get_collider()
		if collision_result.is_in_group("players"):
			if seeking_p1:
				var vectorTowardsPlayer = (Vector3(AstarManager.player1Position.x - dead.position.x, 0, AstarManager.player1Position.z - dead.position.z)).normalized() * speed
				dead.velocity.x = vectorTowardsPlayer.x
				dead.velocity.z = vectorTowardsPlayer.z
			else:
				var vectorTowardsPlayer = (Vector3(AstarManager.player2Position.x - dead.position.x, 0, AstarManager.player2Position.z - dead.position.z)).normalized() * speed
				dead.velocity.x = vectorTowardsPlayer.x
				dead.velocity.z = vectorTowardsPlayer.z
			rotate_towards_movement_direction(dead.velocity, dead.get_child(0))
			dead.move_and_slide()
		else:	
			count += delta
			if count > 1.5 and should_update_path:
				if seeking_p1:
					update_path(AstarManager.find_path(dead.global_transform.origin, AstarManager.player1Position))
				else:
					update_path(AstarManager.find_path(dead.global_transform.origin, AstarManager.player2Position))
				count = 0
				
			if current_target != Vector3.INF:
				var dir_to_target = dead.global_transform.origin.direction_to(current_target).normalized()
				var towardsVector = dir_to_target * speed
				dead.velocity.x = towardsVector.x
				dead.velocity.z = towardsVector.z
				rotate_towards_movement_direction(dead.velocity, dead.get_child(0))
				dead.move_and_slide()
				if dead.global_transform.origin.distance_to(current_target) < 1:
					find_next_point_in_path()
					# if zombie will should fall form tall height
					if(dead.position.y >= current_target[1] + 1.5):
						should_update_path = false
						# dead.velocity.y += speed
						rotate_towards_movement_direction(dead.velocity, dead.get_child(0))
						dead.move_and_slide()
												
					# if zombie will should jump
					# TODO debuggar o valor da comparacao amanha
					print(dead.position.y + 1 < current_target[1] && current_target[1] != INF)
					if(dead.position.y + 1 < current_target[1] && current_target[1] != INF):
						# should_update_path = false
						Transitioned.emit(self, 'DeadJump')
						rotate_towards_movement_direction(dead.velocity, dead.get_child(0))
						dead.move_and_slide()
			else:
				if seeking_p1:
					var vectorTowardsDead = (Vector3(AstarManager.player1Position.x - dead.position.x, 0, AstarManager.player1Position.z - dead.position.z)).normalized() * speed
					dead.velocity.x = vectorTowardsDead.x
					dead.velocity.z = vectorTowardsDead.z
				else:
					var vectorTowardsDead = (Vector3(AstarManager.player2Position.x - dead.position.x, 0, AstarManager.player2Position.z - dead.position.z)).normalized() * speed
					dead.velocity.x = vectorTowardsDead.x
					dead.velocity.z = vectorTowardsDead.z
				rotate_towards_movement_direction(dead.velocity, dead.get_child(0))
				dead.move_and_slide()


func rotate_towards_movement_direction(velocity, object):
	if velocity.length() > 0.2:
			var look_direction = Vector2(velocity.z, velocity.x)
			object.rotation.y = look_direction.angle()

func find_next_point_in_path():
	if path.size() > 0:
		var new_target = path.pop_front()
		current_target = new_target
		if dead.is_on_floor():
			should_update_path = true
	else:
		current_target = Vector3.INF


func update_path(new_path: Array):
	path = new_path
	find_next_point_in_path()

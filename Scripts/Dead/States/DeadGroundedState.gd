extends PlayerState
class_name DeadGrounded

@onready var raycast = get_parent().get_parent().get_parent().get_node("RayCast3D")
@export var dead: CharacterBody3D
@export var animControl: AnimationPlayer

var path := []
var current_target := Vector3.INF
var old_position:String
var speed := RandomNumberGenerator.new().randi_range(2, 3)
var count:float = 0
var should_activate_zombie:bool = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func Enter():
	should_activate_zombie = false
	
func Update(delta: float):
	pass
		
func Physics_Update(delta: float):
	pass

func Exit():
	pass

func check_if_player_is_close_to_attack():
	var dist_to_p1 = dead.global_transform.origin.distance_to(GlobalVariables.player1Position)
	var dist_to_p2 = dead.global_transform.origin.distance_to(GlobalVariables.player2Position)
	if dist_to_p1 < 2 or dist_to_p2 < 2:
		Transitioned.emit(self, 'DeadAttackState')

func checkIfIsDeadDead():
	if dead.isDead:
		Transitioned.emit(self, 'DeadDeadState')

func checkIfTookHit():
	if dead.tookHit:
		Transitioned.emit(self, 'DeadHurtState')

func gravityPhysics(delta: float, jumping: bool):
	var jumpVelocity = 5
	if not dead.is_on_floor():
		dead.velocity.y -= gravity * delta
	
	if jumping and dead.is_on_floor():
		dead.velocity.y = jumpVelocity

	dead.move_and_slide()

func deadMovement(delta: float):

	checkIfTookHit()
	checkIfIsDeadDead()
	
	var dist_to_p1 = dead.global_transform.origin.distance_to(GlobalVariables.player1Position)
	var dist_to_p2 = dead.global_transform.origin.distance_to(GlobalVariables.player2Position)
			
	if (should_activate_zombie == false && (dist_to_p1 > 40 && dist_to_p2 > 40)):
		return
	else:
		should_activate_zombie = true

	var seeking_p1 = dist_to_p1 < dist_to_p2

	if seeking_p1:
		raycast.target_position = (Vector3(GlobalVariables.player1Position.x,GlobalVariables.player1Position.y+1,GlobalVariables.player1Position.z) - dead.position)
	else:
		raycast.target_position = (Vector3(GlobalVariables.player2Position.x,GlobalVariables.player2Position.y+1,GlobalVariables.player2Position.z) - dead.position)
	
	if raycast.get_collider() != null:
		var collision_result = raycast.get_collider()
		
		#searching by vision
		if collision_result.is_in_group("players"):
			if seeking_p1:
				var vectorTowardsPlayer = (Vector3(GlobalVariables.player1Position.x - dead.position.x, 0, GlobalVariables.player1Position.z - dead.position.z)).normalized() * speed
				dead.velocity.x = vectorTowardsPlayer.x
				dead.velocity.z = vectorTowardsPlayer.z
			else:
				var vectorTowardsPlayer = (Vector3(GlobalVariables.player2Position.x - dead.position.x, 0, GlobalVariables.player2Position.z - dead.position.z)).normalized() * speed
				dead.velocity.x = vectorTowardsPlayer.x
				dead.velocity.z = vectorTowardsPlayer.z
			rotate_towards_movement_direction(dead.velocity, dead.get_child(0), delta)
			dead.move_and_slide()
		
		#searching by Astar
		else:
			count += delta
			if count > 1.5 or dead.should_update_path:
				print("UPDATING ASTAR, O BOOL TA : ", dead.should_update_path)
				print("UPDATING ASTAR, O BOOL TA : ", dead.should_update_path)
				#if zombie should fall into crumple state
				if old_position == GlobalVariables.astarNode.world_to_astar(dead.global_transform.origin):
					dead.count_fallen += 1
					if dead.count_fallen > 3.0:
						dead.count_fallen = 0
						Transitioned.emit(self, 'DeadFallen')
				else:
					dead.count_fallen = 0
					
				if seeking_p1:
					update_path(GlobalVariables.astarNode.find_path(dead.global_transform.origin, GlobalVariables.player1Position))
				else:
					update_path(GlobalVariables.astarNode.find_path(dead.global_transform.origin, GlobalVariables.player2Position))
				old_position = GlobalVariables.astarNode.world_to_astar(dead.global_transform.origin)
				count = 0
				dead.should_update_path = false

			if current_target != Vector3.INF:
				var dir_to_target = dead.global_transform.origin.direction_to(current_target).normalized()
				var towardsVector = dir_to_target * speed
				dead.velocity.x = towardsVector.x
				dead.velocity.z = towardsVector.z
				rotate_towards_movement_direction(dead.velocity, dead.get_child(0), delta)
				dead.move_and_slide()
				if dead.global_transform.origin.distance_to(current_target) < 1:
					find_next_point_in_path()
					# if zombie will should fall form tall height
					if(dead.position.y >= current_target[1] + 1.5):
						#should_update_path = false
						# dead.velocity.y += speed
						rotate_towards_movement_direction(dead.velocity, dead.get_child(0), delta)
						dead.move_and_slide()
												
					# if zombie should jump
					if(dead.position.y + 1 < current_target[1] && current_target[1] != INF):
						# should_update_path = false
						Transitioned.emit(self, 'DeadJump')
						rotate_towards_movement_direction(dead.velocity, dead.get_child(0), delta)
						dead.move_and_slide()
			
			#walking straight when no path
			else:
				if dead.is_on_wall():
					dead.count_fallen += delta
					if dead.count_fallen > 4:
						Transitioned.emit(self, 'DeadFallen')
				else:
					dead.count_fallen = 0
				if seeking_p1:
					var vectorTowardsDead = (Vector3(GlobalVariables.player1Position.x - dead.position.x, 0, GlobalVariables.player1Position.z - dead.position.z)).normalized() * speed
					dead.velocity.x = vectorTowardsDead.x
					dead.velocity.z = vectorTowardsDead.z
				else:
					var vectorTowardsDead = (Vector3(GlobalVariables.player2Position.x - dead.position.x, 0, GlobalVariables.player2Position.z - dead.position.z)).normalized() * speed
					dead.velocity.x = vectorTowardsDead.x
					dead.velocity.z = vectorTowardsDead.z
				rotate_towards_movement_direction(dead.velocity, dead.get_child(0), delta)
				dead.move_and_slide()


func rotate_towards_movement_direction(velocity, object, delta):
	if velocity.length() > 0.2:
		var look_direction = Vector2(velocity.z, velocity.x)
		var target_angle = look_direction.angle()
		object.rotation.y = lerp_angle(object.rotation.y, target_angle, 5 * delta)

func find_next_point_in_path():
	if path.size() > 0:
		var new_target = path.pop_front()
		current_target = new_target
		#if dead.is_on_floor():
			#should_update_path = true
	else:
		current_target = Vector3.INF


func update_path(new_path: Array):
	path = new_path
	find_next_point_in_path()

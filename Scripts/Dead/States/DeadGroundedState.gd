extends PlayerState
class_name DeadGrounded

@onready var raycast = get_parent().get_parent().get_parent().get_node("RayCast3D")
@export var dead: CharacterBody3D
@export var animControl: AnimationPlayer

var path := []
var current_target := Vector3.INF
var speed := RandomNumberGenerator.new().randi_range(1, 4)
var count = 0 
var should_update_path:bool = true
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func Enter():
	pass
	
func Update(delta: float):
	pass
		
func Physics_Update(delta: float):
	if (abs(dead.velocity.x) + abs(dead.velocity.z)) == 0:
		Transitioned.emit(self, 'DeadIdle')
	else:
		Transitioned.emit(self, 'DeadWalking')
	pass

func Exit():
	pass

func check_if_player_is_close_to_attack():
	var dist_to_p1 = dead.global_transform.origin.distance_to(AstarManager.player1Position)
	var dist_to_p2 = dead.global_transform.origin.distance_to(AstarManager.player2Position)
	if dist_to_p1 < 2 or dist_to_p2 < 2:
		Transitioned.emit(self, 'DeadAttackState')

func deadMovement(delta: float):
	if not dead.is_on_floor():
		dead.velocity.y -= gravity * delta
	
	var dist_to_p1 = dead.global_transform.origin.distance_to(AstarManager.player1Position)
	var dist_to_p2 = dead.global_transform.origin.distance_to(AstarManager.player2Position)
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
				dead.velocity = (Vector3(AstarManager.player1Position.x - dead.position.x, 0, AstarManager.player1Position.z - dead.position.z)).normalized() * speed
			else:
				dead.velocity = (Vector3(AstarManager.player2Position.x - dead.position.x, 0, AstarManager.player2Position.z - dead.position.z)).normalized() * speed
			rotate_towards_movement_direction(dead.velocity, dead.get_child(0))
			dead.move_and_slide()
		else:	
			count += delta
			if count > 0.5 and should_update_path:
				if seeking_p1:
					update_path(AstarManager.find_path(dead.global_transform.origin, AstarManager.player1Position))
				else:
					update_path(AstarManager.find_path(dead.global_transform.origin, AstarManager.player2Position))
				count = 0
				
			if current_target != Vector3.INF:
				var dir_to_target = dead.global_transform.origin.direction_to(current_target).normalized()
				dead.velocity = dir_to_target * speed
				rotate_towards_movement_direction(dead.velocity, dead.get_child(0))
				dead.move_and_slide()
				if dead.global_transform.origin.distance_to(current_target) < 1:
					find_next_point_in_path()
					if(dead.position.y >= current_target[1] + 1.5):
						should_update_path = false
						dead.velocity.y += speed
						rotate_towards_movement_direction(dead.velocity, dead.get_child(0))
						dead.move_and_slide()
			else:
				if seeking_p1:
					dead.velocity = (Vector3(AstarManager.player1Position.x - dead.position.x, 0, AstarManager.player1Position.z - dead.position.z)).normalized() * speed
				else:
					dead.velocity = (Vector3(AstarManager.player2Position.x - dead.position.x, 0, AstarManager.player2Position.z - dead.position.z)).normalized() * speed
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

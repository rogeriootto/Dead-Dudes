extends CharacterBody3D

@export var lerp_mult : float
@onready var raycast = get_node("RayCast3D")

var path := []
var current_target := Vector3.INF
var speed := 4
var count = 0 
var should_update_path:bool = true
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dist_to_p1:float
var dist_to_p2:float



func _physics_process(delta: float):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	dist_to_p1 = global_transform.origin.distance_to(AstarManager.player1Position)
	dist_to_p2 = global_transform.origin.distance_to(AstarManager.player2Position)
	var seeking_p1 = dist_to_p1 < dist_to_p2
	
	if seeking_p1:
		raycast.target_position = (AstarManager.player1Position - position)
	else:
		raycast.target_position = (AstarManager.player2Position - position)
	
	if raycast.get_collider() != null:
		print(raycast.instance.name)
		var collision_result = raycast.get_collider()
		if collision_result.is_in_group("players"):
			if seeking_p1:
				velocity = (Vector3(AstarManager.player1Position.x - position.x,0,AstarManager.player1Position.z - position.z)).normalized() * speed
			else:
				velocity = (Vector3(AstarManager.player2Position.x - position.x,0,AstarManager.player2Position.z - position.z)).normalized() * speed
			move_and_slide()
		else:			
			count += delta
			if count > 0.5 and should_update_path:
				if seeking_p1:
					update_path(AstarManager.find_path(self.global_transform.origin, AstarManager.player1Position))
				else:
					update_path(AstarManager.find_path(self.global_transform.origin, AstarManager.player2Position))
				count = 0	
				
			if current_target != Vector3.INF:
				var dir_to_target = global_transform.origin.direction_to(current_target).normalized()
				velocity = dir_to_target * lerp_mult		
				move_and_slide()
				if global_transform.origin.distance_to(current_target) < 1:
					find_next_point_in_path()
					if(self.position.y >= current_target[1] + 1.5):
						should_update_path = false
						velocity.y += speed
						move_and_slide()
						
			#this section happens when zombies cant see the player and have no path
			else:
				if seeking_p1:
					velocity = (Vector3(AstarManager.player1Position.x - position.x,0,AstarManager.player1Position.z - position.z)).normalized() * speed
				else:
					velocity = (Vector3(AstarManager.player2Position.x - position.x,0,AstarManager.player2Position.z - position.z)).normalized() * speed
					move_and_slide()



func find_next_point_in_path():
	if path.size() > 0:
		var new_target = path.pop_front()
		current_target = new_target
		if is_on_floor():
			should_update_path = true
	else:
		current_target = Vector3.INF


func update_path(new_path: Array):
	path = new_path
	find_next_point_in_path()

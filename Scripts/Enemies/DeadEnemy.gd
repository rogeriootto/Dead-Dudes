extends CharacterBody3D

@export var lerp_mult : float = 0
var path := []
var current_target := Vector3.INF
var current_velocity := Vector3.ZERO
var speed := 10
var count = 0
var should_update_path:bool = true
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float):
	if count > 0.5 and should_update_path:
		var dist_to_p1 = global_transform.origin.distance_to(AstarManager.player1Position)
		var dist_to_p2 = global_transform.origin.distance_to(AstarManager.player2Position)

		if dist_to_p1 < dist_to_p2:
			update_path(AstarManager.find_path(self.global_transform.origin, AstarManager.player1Position))
		else:
			update_path(AstarManager.find_path(self.global_transform.origin, AstarManager.player2Position))
		count = 0
	count += delta
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	var lerp_weight = delta * lerp_mult

	if current_target != Vector3.INF:
		var dir_to_target = global_transform.origin.direction_to(current_target).normalized()
		velocity = dir_to_target * lerp_mult
		if global_transform.origin.distance_to(current_target) < 1:
			find_next_point_in_path()
			print(current_target)
			if(self.position.y >= current_target[1] + 1.5):
				should_update_path = false
				velocity.y += speed
				move_and_slide()
			
	else:
		#TODO Colocar aqui o comportamento do zumbi quando ele não encontra um caminho
		velocity = lerp(velocity, Vector3.ZERO, lerp_weight)
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

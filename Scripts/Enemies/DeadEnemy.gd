extends CharacterBody3D

@export var lerp_mult : float = 0
var path := []
var current_target := Vector3.INF
var current_velocity := Vector3.ZERO
var speed := 3.0
var count = 0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float):
	if count > 0.5:
		update_path(AstarManager.find_path(self.global_transform.origin, AstarManager.player1Position))
		count = 0
	count += delta
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	var lerp_weight = delta * lerp_mult

	if current_target != Vector3.INF:
		var dir_to_target = global_transform.origin.direction_to(current_target).normalized()
		velocity = dir_to_target * lerp_mult
		if global_transform.origin.distance_to(current_target) < 1.0:
			find_next_point_in_path()
	else:
		velocity = lerp(velocity, Vector3.ZERO, lerp_weight)
	move_and_slide()


func find_next_point_in_path():
	if path.size() > 0:
		var new_target = path.pop_front()
		current_target = new_target
	else:
		current_target = Vector3.INF


func update_path(new_path: Array):
	path = new_path
	find_next_point_in_path()

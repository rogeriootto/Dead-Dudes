extends Node3D

@export var should_draw_cubes := false

var astar = AStar3D.new()
var grid_step := 1.5 #size of the grid's cells
var points := {}

var cube_mesh = BoxMesh.new()
var red_material = StandardMaterial3D.new()
var green_material = StandardMaterial3D.new()

func _ready():
	red_material.albedo_color = Color.RED
	green_material.albedo_color = Color.GREEN
	cube_mesh.size = Vector3(0.25, 0.25, 0.25)
	var pathables = get_tree().get_nodes_in_group("pathable")
	_add_points(pathables)
	_connect_points()

func _add_points(pathables: Array):
	for pathable in pathables:
		var mesh = pathable.get_node("MeshInstance3D")
#		var aabb: AABB = mesh.get_transformed_aabb()   isso era usado no godot 3
		var aabb: AABB = mesh.global_transform * mesh.get_aabb() 

		var start_point = aabb.position

		var x_steps = aabb.size.x / grid_step
		var y_steps = aabb.size.y / grid_step
		var z_steps = aabb.size.z / grid_step
		var offset_point = Vector3(grid_step/2, grid_step/2, grid_step/2)
		
		for x in x_steps:
			for y in y_steps:
				for z in z_steps:
					var next_point = start_point + Vector3(x * grid_step, (y * grid_step), z * grid_step) + offset_point
					_add_point(next_point)
				
func _add_point(point: Vector3):
#	point.y = grid_y
	var id = astar.get_available_point_id()

	astar.add_point(id, point)
	points[world_to_astar(point)] = id
	_create_nav_cube(point)

func _connect_points():
	for point in points:
		var pos_str = point.split(",")
		var world_pos := Vector3(float(pos_str[0]), float(pos_str[1]), float(pos_str[2]))
		var adjacent_points = _get_adjacent_points(world_pos)
		var current_id = points[point]
		for neighbor_id in adjacent_points:
			if not astar.are_points_connected(current_id, neighbor_id):
				astar.connect_points(current_id, neighbor_id)
				if should_draw_cubes:
					get_child(current_id).material_override = green_material
					get_child(neighbor_id).material_override = green_material

func _get_adjacent_points(world_point: Vector3) -> Array:
	var adjacent_points = []
	var search_coords = [-grid_step, 0, grid_step]
	for x in search_coords:
		for y in search_coords:
			for z in search_coords:
				var search_offset = Vector3(x, y, z)
				if search_offset == Vector3.ZERO:
					continue
				var potential_neighbor = world_to_astar(world_point + search_offset)
				if points.has(potential_neighbor):
					adjacent_points.append(points[potential_neighbor])
	return adjacent_points


func find_path(from: Vector3, to: Vector3) -> Array:
	var start_id = astar.get_closest_point(from)
	var end_id = astar.get_closest_point(to)
	return astar.get_point_path(start_id, end_id)


func world_to_astar(world: Vector3) -> String:
	var x = snapped(world.x, grid_step)
	var y = snapped(world.y, grid_step)
	var z = snapped(world.z, grid_step)
	return "%d,%d,%d" % [x, y, z]	


func _create_nav_cube(point_position: Vector3):
	if should_draw_cubes:
		var cube = MeshInstance3D.new()
		cube.mesh = cube_mesh
		cube.material_override = red_material
		add_child(cube)
#		position.y = grid_y
		cube.global_transform.origin = point_position
#		cube.global_transform.origin.y += 0.5


func _on_main_obstacle_should_spawn():
	var viewport := get_viewport()
	var mouse_position := viewport.get_mouse_position()
	var camera := viewport.get_camera_3d()
	var origin := camera.project_ray_origin(mouse_position)
	var direction := camera.project_ray_normal(mouse_position)
	var ray_length := camera.far
	var end := origin + direction * ray_length
	var space_state := get_world_3d().direct_space_state
	
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	var result := space_state.intersect_ray(query)
	
	if not result.is_empty():

		var adjacent_points: Array = []
		var point_key = world_to_astar(result.position)
		var astar_id = points[point_key]
		adjacent_points.append(astar_id)

		for point in adjacent_points:
			if not astar.is_point_disabled(point):
				astar.set_point_disabled(point, true)
				if should_draw_cubes:
					get_child(point).material_override = red_material


extends Node3D

@export var should_draw_cubes := false
@export var signal_manager: Node3D

var astar = AStar3D.new()
const grid_step := 1.5 #size of the grid's cells
var points := {}

var cube_mesh = BoxMesh.new()
var red_material = StandardMaterial3D.new()
var green_material = StandardMaterial3D.new()

var obstacleDictionary = {"box1x1": preload("res://Scenes/Objects/Obstacles/obstacle.tscn"), "policeCar": preload("res://Scenes/Objects/Obstacles/policeCar.tscn")}
var buildingShowObject

func _ready():
	red_material.albedo_color = Color.RED
	green_material.albedo_color = Color.GREEN
	cube_mesh.size = Vector3(0.25, 0.25, 0.25)
	var pathables = get_tree().get_nodes_in_group("pathable")
	_make_grid(pathables)
	_connect_points()
	signal_manager.registerListner('obstacleSpawnRequest', self, "_on_main_obstacle_should_spawn")
	signal_manager.registerListner('showObstacleRequest', self, "_on_main_obstacle_should_show")

func _make_grid(pathables: Array):
	for pathable in pathables:
		var mesh = pathable.get_node("MeshInstance3D")
#		var aabb: AABB = mesh.get_transformed_aabb()   isso era usado no godot 3
		var aabb: AABB = mesh.global_transform * mesh.get_aabb() 

		var start_point = aabb.position

		#talvez precise discretizar isso ja que eh usado pra iterar o proximo loop
		# o X e o Z steps dividem o chao para o grid
		#o y do nextpoint ta atrelado ao grid step, então o tamanho dos obstaculos tb tem q ser

		var x_steps = aabb.size.x / grid_step
		var z_steps = aabb.size.z / grid_step
		var y_height = aabb.size.y
		var offset_point = Vector3(grid_step/2, grid_step/2, grid_step/2)
		
		for x in x_steps:
#			for y in y_steps:
			for y in 3:
				for z in z_steps:
					
					var next_point = start_point + Vector3(x * grid_step, y_height + (y * grid_step), z * grid_step) + offset_point
					_add_point(next_point)
				
func _add_point(point: Vector3):
#	point.y = grid_y
	var id = astar.get_available_point_id()
	
	#ALTURA HARD CODED ARRUMAR
	var astar_weight = 1 + ((point.y -0.5) * 20)

	astar.add_point(id, point, astar_weight)
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
	
	#esse if else eh hard code pra so conectar a primeira camada
#	print(world_point[1])
	if world_point[1] == 1:
		var adjacent_points = []
		var search_coords = [-grid_step, 0, grid_step]
		for x in search_coords:
			for z in search_coords:
				var search_offset = Vector3(x, 0, z)
				if search_offset == Vector3.ZERO:
					continue
				var potential_neighbor = world_to_astar(world_point + search_offset)
				if points.has(potential_neighbor):
					adjacent_points.append(points[potential_neighbor])
		return adjacent_points
	else: 
		var adjacent_points = []
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
		#TODO: TIRAR ESSE IF DO CARALHO
		if point_position.y < grid_step * 2:
			cube.mesh = cube_mesh
			cube.material_override = red_material
		add_child(cube)
#		position.y = grid_y
		cube.global_transform.origin = point_position

func _on_main_obstacle_should_spawn(obstacleName: String, obstaclePosition: Vector3):
	if obstacleDictionary[obstacleName] and obstaclePosition.y > 0:
		
		obstaclePosition.x = snapped(obstaclePosition.x, grid_step) - grid_step/2
		obstaclePosition.y = snapped(obstaclePosition.y, grid_step)
		obstaclePosition.z = snapped(obstaclePosition.z, grid_step) - grid_step/2

		if obstaclePosition.y < 1:
			obstaclePosition.y = 1.5

		var point_key = world_to_astar(obstaclePosition)
		var obstacle_id

		if points.has(point_key):
			obstacle_id = points[point_key]
		else:
			return

		if not astar.is_point_disabled(obstacle_id):
			var obstacle = obstacleDictionary[obstacleName].instantiate()
			obstacle.position = obstaclePosition
			add_child(obstacle)
			obstacle.add_to_group("obstacle")	
			print(obstacle_id)

			astar.set_point_disabled(obstacle_id, true)
			if should_draw_cubes:
				get_child(obstacle_id).material_override = red_material

func _on_main_obstacle_should_show(showObjectFlag: bool, obstacleName: String, obstaclePosition: Vector3):

	if !buildingShowObject:
		buildingShowObject = obstacleDictionary[obstacleName].instantiate()
		add_child(buildingShowObject)
		buildingShowObject.get_node("CollisionShape3D").disabled = true

		# var objectColor = StandardMaterial3D.new()
		# objectColor.albedo_color = Color(1,1,1,0.1)
		# buildingShowObject.get_node("MeshInstance3D").material_override = objectColor

	if showObjectFlag:
		obstaclePosition.x = snapped(obstaclePosition.x, grid_step) - grid_step/2
		obstaclePosition.y = snapped(obstaclePosition.y, grid_step)
		obstaclePosition.z = snapped(obstaclePosition.z, grid_step) - grid_step/2
		if obstaclePosition.y < 1:
			obstaclePosition.y = 1.5
		buildingShowObject.position = obstaclePosition
	else:
		buildingShowObject.queue_free()
			
#funcao guardada pra backup

#func _get_adjacent_points(world_point: Vector3) -> Array:
	
#	var adjacent_points = []
#	var search_coords = [-grid_step, 0, grid_step]
#	for x in search_coords:
#		for y in search_coords:
#			for z in search_coords:
#				var search_offset = Vector3(x, y, z)
#				if search_offset == Vector3.ZERO:
#					continue
#				var potential_neighbor = world_to_astar(world_point + search_offset)
#				if points.has(potential_neighbor):
#					adjacent_points.append(points[potential_neighbor])
#	return adjacent_points
